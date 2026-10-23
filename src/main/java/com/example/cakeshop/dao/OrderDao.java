package com.example.cakeshop.dao;

import com.example.cakeshop.model.Order;
import com.example.cakeshop.model.OrderItem;

import java.math.BigDecimal;
import java.util.List;

/**
 * 订单数据访问接口
 */
public interface OrderDao {

    int insert(Order order);

    int insertItem(OrderItem item);

    List<Order> findByUserId(Integer userId, Integer status, int offset, int pageSize);

    int countByUserId(Integer userId, Integer status);

    Order findById(Integer id);

    Order findByOrderNo(String orderNo);

    List<OrderItem> findItemsByOrderId(Integer orderId);

    int updateStatus(Integer id, Integer status);

    int updatePayTime(Integer id);

    int updateShipTime(Integer id);

    int updateReceiveTime(Integer id);

    List<Order> findAll(Integer status, int offset, int pageSize);

    int count(Integer status);

    int countToday();

    BigDecimal sumTodaySales();
}
