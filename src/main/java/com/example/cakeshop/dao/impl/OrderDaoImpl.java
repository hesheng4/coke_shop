package com.example.cakeshop.dao.impl;

import com.example.cakeshop.dao.JdbcTemplate;
import com.example.cakeshop.dao.OrderDao;
import com.example.cakeshop.model.Order;
import com.example.cakeshop.model.OrderItem;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 基于 JDBC 模板的订单数据访问实现
 */
public class OrderDaoImpl implements OrderDao {

    private static final String INSERT_SQL =
            "INSERT INTO `order` (order_no, user_id, total_amount, pay_amount, coupon_id, discount_amount, "
                    + "status, receiver_name, receiver_phone, receiver_address, delivery_time, remark) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String INSERT_ITEM_SQL =
            "INSERT INTO order_item (order_id, product_id, product_name, product_image, spec_id, spec_name, price, quantity, total_price) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_BASE = "SELECT * FROM `order`";
    private static final String SELECT_BY_ID = SELECT_BASE + " WHERE id = ?";
    private static final String SELECT_BY_ORDER_NO = SELECT_BASE + " WHERE order_no = ?";
    private static final String SELECT_ITEMS = "SELECT * FROM order_item WHERE order_id = ?";
    private static final String UPDATE_STATUS = "UPDATE `order` SET status = ? WHERE id = ?";
    private static final String UPDATE_PAY_TIME = "UPDATE `order` SET pay_time = NOW(), status = 1 WHERE id = ? AND status = 0";
    private static final String UPDATE_SHIP_TIME = "UPDATE `order` SET ship_time = NOW(), status = 2 WHERE id = ? AND status = 1";
    private static final String UPDATE_RECEIVE_TIME = "UPDATE `order` SET receive_time = NOW(), status = 3 WHERE id = ? AND status = 2";
    private static final String COUNT_TODAY = "SELECT COUNT(*) FROM `order` WHERE DATE(create_time) = CURDATE()";
    private static final String SUM_TODAY_SALES =
            "SELECT COALESCE(SUM(pay_amount), 0) FROM `order` WHERE DATE(create_time) = CURDATE() AND status IN (1, 2, 3)";

    @Override
    public int insert(Order order) {
        return JdbcTemplate.insert(INSERT_SQL,
                order.getOrderNo(),
                order.getUserId(),
                order.getTotalAmount(),
                order.getPayAmount(),
                order.getCouponId(),
                order.getDiscountAmount(),
                order.getStatus(),
                order.getReceiverName(),
                order.getReceiverPhone(),
                order.getReceiverAddress(),
                order.getDeliveryTime(),
                order.getRemark());
    }

    @Override
    public int insertItem(OrderItem item) {
        return JdbcTemplate.update(INSERT_ITEM_SQL,
                item.getOrderId(),
                item.getProductId(),
                item.getProductName(),
                item.getProductImage(),
                item.getSpecId(),
                item.getSpecName(),
                item.getPrice(),
                item.getQuantity(),
                item.getTotalPrice());
    }

    @Override
    public List<Order> findByUserId(Integer userId, Integer status, int offset, int pageSize) {
        List<Object> params = new ArrayList<>();
        params.add(userId);
        String sql = appendStatus(SELECT_BASE + " WHERE user_id = ?", status, params)
                + " ORDER BY create_time DESC LIMIT ?, ?";
        params.add(offset);
        params.add(pageSize);
        return JdbcTemplate.query(sql, this::mapRow, params.toArray());
    }

    @Override
    public int countByUserId(Integer userId, Integer status) {
        List<Object> params = new ArrayList<>();
        params.add(userId);
        Integer count = JdbcTemplate.queryScalar(
                appendStatus("SELECT COUNT(*) FROM `order` WHERE user_id = ?", status, params),
                Integer.class, params.toArray());
        return count == null ? 0 : count;
    }

    @Override
    public Order findById(Integer id) {
        return JdbcTemplate.queryFirst(SELECT_BY_ID, this::mapRow, id);
    }

    @Override
    public Order findByOrderNo(String orderNo) {
        return JdbcTemplate.queryFirst(SELECT_BY_ORDER_NO, this::mapRow, orderNo);
    }

    @Override
    public List<OrderItem> findItemsByOrderId(Integer orderId) {
        return JdbcTemplate.query(SELECT_ITEMS, this::mapItem, orderId);
    }

    @Override
    public int updateStatus(Integer id, Integer status) {
        return JdbcTemplate.update(UPDATE_STATUS, status, id);
    }

    @Override
    public int updatePayTime(Integer id) {
        return JdbcTemplate.update(UPDATE_PAY_TIME, id);
    }

    @Override
    public int updateShipTime(Integer id) {
        return JdbcTemplate.update(UPDATE_SHIP_TIME, id);
    }

    @Override
    public int updateReceiveTime(Integer id) {
        return JdbcTemplate.update(UPDATE_RECEIVE_TIME, id);
    }

    @Override
    public List<Order> findAll(Integer status, int offset, int pageSize) {
        List<Object> params = new ArrayList<>();
        String sql = appendStatus(SELECT_BASE, status, params) + " ORDER BY create_time DESC LIMIT ?, ?";
        params.add(offset);
        params.add(pageSize);
        return JdbcTemplate.query(sql, this::mapRow, params.toArray());
    }

    @Override
    public int count(Integer status) {
        List<Object> params = new ArrayList<>();
        Integer count = JdbcTemplate.queryScalar(appendStatus("SELECT COUNT(*) FROM `order`", status, params),
                Integer.class, params.toArray());
        return count == null ? 0 : count;
    }

    @Override
    public int countToday() {
        Integer count = JdbcTemplate.queryScalar(COUNT_TODAY, Integer.class);
        return count == null ? 0 : count;
    }

    @Override
    public BigDecimal sumTodaySales() {
        BigDecimal sum = JdbcTemplate.queryScalar(SUM_TODAY_SALES, BigDecimal.class);
        return sum == null ? BigDecimal.ZERO : sum;
    }

    private String appendStatus(String sql, Integer status, List<Object> params) {
        if (status == null) {
            return sql;
        }
        params.add(status);
        return sql + (sql.indexOf("WHERE") >= 0 ? " AND" : " WHERE") + " status = ?";
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setOrderNo(rs.getString("order_no"));
        order.setUserId(rs.getInt("user_id"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setPayAmount(rs.getBigDecimal("pay_amount"));
        order.setCouponId(rs.getObject("coupon_id") != null ? rs.getInt("coupon_id") : null);
        order.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        order.setStatus(rs.getInt("status"));
        order.setReceiverName(rs.getString("receiver_name"));
        order.setReceiverPhone(rs.getString("receiver_phone"));
        order.setReceiverAddress(rs.getString("receiver_address"));
        order.setDeliveryTime(rs.getString("delivery_time"));
        order.setRemark(rs.getString("remark"));
        order.setPayTime(rs.getTimestamp("pay_time"));
        order.setShipTime(rs.getTimestamp("ship_time"));
        order.setReceiveTime(rs.getTimestamp("receive_time"));
        order.setCreateTime(rs.getTimestamp("create_time"));
        order.setUpdateTime(rs.getTimestamp("update_time"));
        return order;
    }

    private OrderItem mapItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setId(rs.getInt("id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setProductName(rs.getString("product_name"));
        item.setProductImage(rs.getString("product_image"));
        int specId = rs.getInt("spec_id");
        item.setSpecId(rs.wasNull() ? null : specId);
        item.setSpecName(rs.getString("spec_name"));
        item.setPrice(rs.getBigDecimal("price"));
        item.setQuantity(rs.getInt("quantity"));
        item.setTotalPrice(rs.getBigDecimal("total_price"));
        item.setCreateTime(rs.getTimestamp("create_time"));
        return item;
    }
}
