package com.example.cakeshop.controller;

import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.model.Address;
import com.example.cakeshop.model.Order;
import com.example.cakeshop.model.User;
import com.example.cakeshop.service.AddressService;
import com.example.cakeshop.service.OrderService;
import com.example.cakeshop.service.impl.AddressServiceImpl;
import com.example.cakeshop.service.impl.OrderServiceImpl;
import com.example.cakeshop.util.ApiRouter;
import com.example.cakeshop.util.JsonUtil;
import com.example.cakeshop.util.PageUtil;
import com.example.cakeshop.util.SessionUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 订单控制器：下单、支付、取消、收货与订单查询。
 * 登录校验由 AccessControlFilter 负责，这里只做归属校验。
 */
@WebServlet("/api/order/*")
public class OrderController extends AbstractApiServlet {

    private static final long serialVersionUID = 1L;

    private final OrderService orderService = new OrderServiceImpl();
    private final AddressService addressService = new AddressServiceImpl();

    @Override
    protected ApiRouter buildRouter() {
        return new ApiRouter()
                .on("GET", "list", this::list)
                .on("GET", "detail", this::detail)
                .on("POST", "create", this::create)
                .on("POST", "pay", this::pay)
                .on("POST", "cancel", this::cancel)
                .on("POST", "confirm", this::confirm);
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = requireUser(request);
        Integer status = parseOptionalInt(request.getParameter("status"), null);
        int page = parseOptionalInt(request.getParameter("page"), 1);
        int pageSize = parseOptionalInt(request.getParameter("pageSize"), 10);

        PageUtil pageUtil = new PageUtil(page, pageSize);
        List<Order> orders = orderService.findByUserId(user.getId(), status, page, pageSize);
        pageUtil.setTotalCount(orderService.countByUserId(user.getId(), status));

        JsonUtil.writeSuccess(response, pageResult(orders, pageUtil));
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = requireUser(request);
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            throw new ServiceException("订单ID不能为空");
        }
        Order order = orderService.findById(parseOrderId(idStr));
        if (order == null || !order.getUserId().equals(user.getId())) {
            throw new ServiceException("订单不存在");
        }
        JsonUtil.writeSuccess(response, order);
    }

    private void create(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = requireUser(request);
        String cartIdsStr = request.getParameter("cartIds");
        String addressIdStr = request.getParameter("addressId");

        if (cartIdsStr == null || cartIdsStr.isEmpty()) {
            throw new ServiceException("请选择商品");
        }
        if (addressIdStr == null || addressIdStr.isEmpty()) {
            throw new ServiceException("请选择收货地址");
        }

        List<Integer> cartIds = parseCartIds(cartIdsStr);
        Address address = addressService.findById(parseId(addressIdStr, "地址ID格式错误"));
        if (address == null || !address.getUserId().equals(user.getId())) {
            throw new ServiceException("收货地址不存在");
        }

        Order order = orderService.createOrder(user.getId(), cartIds, address,
                request.getParameter("deliveryTime"), request.getParameter("remark"));
        if (order == null) {
            throw new ServiceException("下单失败");
        }
        JsonUtil.writeSuccess(response, "下单成功", order);
    }

    private void pay(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = requireUser(request);
        int orderId = requireOrderId(request);
        if (!orderService.payOrder(orderId, user.getId())) {
            throw new ServiceException("支付失败");
        }
        JsonUtil.writeSuccess(response, "支付成功");
    }

    private void cancel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = requireUser(request);
        int orderId = requireOrderId(request);
        if (!orderService.cancelOrder(orderId, user.getId())) {
            throw new ServiceException("取消失败");
        }
        JsonUtil.writeSuccess(response, "取消成功");
    }

    private void confirm(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = requireUser(request);
        int orderId = requireOrderId(request);
        if (!orderService.confirmReceive(orderId, user.getId())) {
            throw new ServiceException("确认收货失败");
        }
        JsonUtil.writeSuccess(response, "确认收货成功");
    }

    private User requireUser(HttpServletRequest request) {
        User user = SessionUtil.currentUser(request);
        if (user == null) {
            throw new ServiceException(401, "请先登录");
        }
        return user;
    }

    private int requireOrderId(HttpServletRequest request) {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            throw new ServiceException("订单ID不能为空");
        }
        return parseOrderId(orderIdStr);
    }

    private int parseOrderId(String value) {
        return parseId(value, "订单ID格式错误");
    }

    private int parseId(String value, String errorMessage) {
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            throw new ServiceException(errorMessage);
        }
    }

    private int parseOptionalInt(String value, int defaultValue) {
        Integer parsed = optionalInt(value);
        return parsed == null ? defaultValue : parsed;
    }

    private Integer parseOptionalInt(String value, Integer defaultValue) {
        Integer parsed = optionalInt(value);
        return parsed == null ? defaultValue : parsed;
    }

    private Integer optionalInt(String value) {
        if (value == null || value.isEmpty()) {
            return null;
        }
        try {
            return Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private List<Integer> parseCartIds(String cartIdsStr) {
        List<Integer> cartIds = new ArrayList<>();
        for (String part : cartIdsStr.split(",")) {
            try {
                cartIds.add(Integer.valueOf(part.trim()));
            } catch (NumberFormatException e) {
                throw new ServiceException("购物车ID格式错误");
            }
        }
        return cartIds;
    }

    private Map<String, Object> pageResult(List<Order> orders, PageUtil pageUtil) {
        Map<String, Object> result = new HashMap<>();
        result.put("list", orders);
        result.put("page", pageUtil.getPageInfo());
        return result;
    }
}
