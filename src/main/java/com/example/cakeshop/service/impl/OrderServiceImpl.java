package com.example.cakeshop.service.impl;

import com.example.cakeshop.dao.CartDao;
import com.example.cakeshop.dao.OrderDao;
import com.example.cakeshop.dao.ProductDao;
import com.example.cakeshop.dao.impl.CartDaoImpl;
import com.example.cakeshop.dao.impl.OrderDaoImpl;
import com.example.cakeshop.dao.impl.ProductDaoImpl;
import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.model.Address;
import com.example.cakeshop.model.Cart;
import com.example.cakeshop.model.Order;
import com.example.cakeshop.model.OrderItem;
import com.example.cakeshop.model.ProductSpec;
import com.example.cakeshop.service.OrderService;
import com.example.cakeshop.tx.TransactionManager;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

/**
 * 订单实现：下单、取消都是“订单 + 明细 + 库存 + 购物车”的多表写入，统一放在一个 JDBC 事务里。
 */
public class OrderServiceImpl implements OrderService {

    private static final int STATUS_UNPAID = 0;
    private static final int STATUS_UNSHIPPED = 1;
    private static final int STATUS_UNRECEIVED = 2;
    private static final int STATUS_CANCELLED = 4;

    private static final BigDecimal ZERO = BigDecimal.ZERO;

    private final OrderDao orderDao = new OrderDaoImpl();
    private final CartDao cartDao = new CartDaoImpl();
    private final ProductDao productDao = new ProductDaoImpl();

    @Override
    public Order createOrder(Integer userId, List<Integer> cartIds, Address address, String deliveryTime, String remark) {
        return TransactionManager.execute(context -> {
            List<Cart> carts = loadOwnedCarts(userId, cartIds);
            if (carts.isEmpty()) {
                return null;
            }
            Order order = new Order();
            order.setOrderNo(generateOrderNo());
            order.setUserId(userId);
            BigDecimal totalAmount = sumAmount(carts);
            order.setTotalAmount(totalAmount);
            order.setPayAmount(totalAmount);
            order.setDiscountAmount(ZERO);
            order.setStatus(STATUS_UNPAID);
            order.setReceiverName(address.getReceiverName());
            order.setReceiverPhone(address.getReceiverPhone());
            order.setReceiverAddress(address.getFullAddress());
            order.setDeliveryTime(deliveryTime);
            order.setRemark(remark);

            int orderId = orderDao.insert(order);
            if (orderId <= 0) {
                throw new ServiceException("下单失败");
            }
            for (Cart cart : carts) {
                orderDao.insertItem(buildItem(orderId, cart));
                deductStock(cart);
            }
            cartDao.deleteByIds(cartIds);
            order.setId(orderId);
            return order;
        });
    }

    @Override
    public List<Order> findByUserId(Integer userId, Integer status, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return loadItems(orderDao.findByUserId(userId, status, offset, pageSize));
    }

    @Override
    public int countByUserId(Integer userId, Integer status) {
        return orderDao.countByUserId(userId, status);
    }

    @Override
    public Order findById(Integer id) {
        Order order = orderDao.findById(id);
        if (order != null) {
            order.setItems(orderDao.findItemsByOrderId(id));
        }
        return order;
    }

    @Override
    public Order findByOrderNo(String orderNo) {
        Order order = orderDao.findByOrderNo(orderNo);
        if (order != null) {
            order.setItems(orderDao.findItemsByOrderId(order.getId()));
        }
        return order;
    }

    @Override
    public boolean cancelOrder(Integer orderId, Integer userId) {
        Order order = orderDao.findById(orderId);
        if (order == null || !order.getUserId().equals(userId) || order.getStatus() != STATUS_UNPAID) {
            return false;
        }
        return TransactionManager.execute(context -> {
            for (OrderItem item : orderDao.findItemsByOrderId(orderId)) {
                productDao.restoreStock(item.getProductId(), item.getQuantity());
                productDao.restoreSales(item.getProductId(), item.getQuantity());
                if (item.getSpecId() != null) {
                    productDao.restoreSpecStock(item.getSpecId(), item.getQuantity());
                }
            }
            return orderDao.updateStatus(orderId, STATUS_CANCELLED) > 0;
        });
    }

    @Override
    public boolean confirmReceive(Integer orderId, Integer userId) {
        Order order = orderDao.findById(orderId);
        if (order == null || !order.getUserId().equals(userId) || order.getStatus() != STATUS_UNRECEIVED) {
            return false;
        }
        return orderDao.updateReceiveTime(orderId) > 0;
    }

    @Override
    public boolean payOrder(Integer orderId, Integer userId) {
        Order order = orderDao.findById(orderId);
        if (order == null || !order.getUserId().equals(userId) || order.getStatus() != STATUS_UNPAID) {
            return false;
        }
        return orderDao.updatePayTime(orderId) > 0;
    }

    @Override
    public List<Order> findAll(Integer status, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return loadItems(orderDao.findAll(status, offset, pageSize));
    }

    @Override
    public int count(Integer status) {
        return orderDao.count(status);
    }

    @Override
    public boolean shipOrder(Integer orderId) {
        Order order = orderDao.findById(orderId);
        if (order == null || order.getStatus() != STATUS_UNSHIPPED) {
            return false;
        }
        return orderDao.updateShipTime(orderId) > 0;
    }

    @Override
    public int countToday() {
        return orderDao.countToday();
    }

    @Override
    public BigDecimal sumTodaySales() {
        return orderDao.sumTodaySales();
    }

    private List<Order> loadItems(List<Order> orders) {
        for (Order order : orders) {
            order.setItems(orderDao.findItemsByOrderId(order.getId()));
        }
        return orders;
    }

    private List<Cart> loadOwnedCarts(Integer userId, List<Integer> cartIds) {
        List<Cart> carts = new ArrayList<>();
        for (Integer cartId : cartIds) {
            Cart cart = cartDao.findById(cartId);
            if (cart != null && userId.equals(cart.getUserId())) {
                carts.add(cart);
            }
        }
        return carts;
    }

    private BigDecimal sumAmount(List<Cart> carts) {
        BigDecimal total = ZERO;
        for (Cart cart : carts) {
            total = total.add(unitPrice(cart).multiply(new BigDecimal(cart.getQuantity())));
        }
        return total;
    }

    private OrderItem buildItem(Integer orderId, Cart cart) {
        BigDecimal price = unitPrice(cart);
        OrderItem item = new OrderItem();
        item.setOrderId(orderId);
        item.setProductId(cart.getProductId());
        item.setProductName(cart.getProduct().getName());
        item.setProductImage(cart.getProduct().getImage());
        ProductSpec spec = cart.getSpec();
        if (spec != null && spec.getPrice() != null) {
            item.setSpecName(spec.getSpecName() + ":" + spec.getSpecValue());
        }
        item.setSpecId(cart.getSpecId());
        item.setPrice(price);
        item.setQuantity(cart.getQuantity());
        item.setTotalPrice(price.multiply(new BigDecimal(cart.getQuantity())));
        return item;
    }

    /**
     * 库存递减的 SQL 带 stock >= ? 条件，影响 0 行即库存不足，抛异常让整单回滚。
     */
    private void deductStock(Cart cart) {
        int quantity = cart.getQuantity();
        if (productDao.updateStock(cart.getProductId(), quantity) <= 0) {
            throw new ServiceException("商品库存不足，请重新下单");
        }
        productDao.updateSales(cart.getProductId(), quantity);
        Integer specId = cart.getSpecId();
        if (specId != null && productDao.updateSpecStock(specId, quantity) <= 0) {
            throw new ServiceException("商品规格库存不足，请重新下单");
        }
    }

    private BigDecimal unitPrice(Cart cart) {
        ProductSpec spec = cart.getSpec();
        if (spec != null && spec.getPrice() != null) {
            return spec.getPrice();
        }
        return cart.getProduct().getPrice();
    }

    private String generateOrderNo() {
        return new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
                + (ThreadLocalRandom.current().nextInt(9000) + 1000);
    }
}
