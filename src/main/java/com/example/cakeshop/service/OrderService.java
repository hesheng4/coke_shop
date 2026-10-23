package com.example.cakeshop.service;

import com.example.cakeshop.model.Address;
import com.example.cakeshop.model.Order;

import java.math.BigDecimal;
import java.util.List;

/**
 * 订单业务逻辑接口
 */
public interface OrderService {

    Order createOrder(Integer userId, List<Integer> cartIds, Address address, String deliveryTime, String remark);

    List<Order> findByUserId(Integer userId, Integer status, int page, int pageSize);

    int countByUserId(Integer userId, Integer status);

    Order findById(Integer id);

    Order findByOrderNo(String orderNo);

    boolean cancelOrder(Integer orderId, Integer userId);

    boolean confirmReceive(Integer orderId, Integer userId);

    boolean payOrder(Integer orderId, Integer userId);

    List<Order> findAll(Integer status, int page, int pageSize);

    int count(Integer status);

    boolean shipOrder(Integer orderId);

    int countToday();

    BigDecimal sumTodaySales();
}
