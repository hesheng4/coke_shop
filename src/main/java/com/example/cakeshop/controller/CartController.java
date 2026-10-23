package com.example.cakeshop.controller;

import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.model.Cart;
import com.example.cakeshop.service.CartService;
import com.example.cakeshop.service.impl.CartServiceImpl;
import com.example.cakeshop.util.ApiRouter;
import com.example.cakeshop.util.JsonUtil;
import com.example.cakeshop.util.SessionUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 购物车控制器：路由表分发。会话校验由 AccessControlFilter 负责（/api/cart/count 允许匿名）。
 */
@WebServlet("/api/cart/*")
public class CartController extends AbstractApiServlet {

    private static final long serialVersionUID = 1L;

    private final CartService cartService = new CartServiceImpl();

    @Override
    protected ApiRouter buildRouter() {
        return new ApiRouter()
                .on("GET", "list", this::list)
                .on("GET", "count", this::count)
                .on("POST", "add", this::add)
                .on("PUT", "{cartId}", this::updateQuantity)
                .on("DELETE", "{cartId}", this::remove);
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer userId = SessionUtil.currentUserId(request);
        List<Cart> cartList = cartService.findByUserId(userId);
        JsonUtil.writeSuccess(response, cartList);
    }

    private void count(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 匿名首页角标依赖此接口：未登录返回 0，不返回 401
        Integer userId = SessionUtil.currentUserId(request);
        JsonUtil.writeSuccess(response, userId == null ? 0 : cartService.count(userId));
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer userId = SessionUtil.currentUserId(request);

        String productIdStr = request.getParameter("productId");
        String specIdStr = request.getParameter("specId");
        String quantityStr = request.getParameter("quantity");

        if (productIdStr == null || productIdStr.isEmpty()) {
            throw new ServiceException("商品ID不能为空");
        }
        int productId;
        try {
            productId = Integer.parseInt(productIdStr);
        } catch (NumberFormatException e) {
            throw new ServiceException("商品ID格式错误");
        }

        Integer specId = null;
        if (specIdStr != null && !specIdStr.isEmpty()) {
            try {
                specId = Integer.parseInt(specIdStr);
            } catch (NumberFormatException e) {
                throw new ServiceException("规格ID格式错误");
            }
        }

        int quantity = 1;
        if (quantityStr != null && !quantityStr.isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity <= 0) {
                    quantity = 1;
                }
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }

        Cart cart = new Cart();
        cart.setUserId(userId);
        cart.setProductId(productId);
        cart.setSpecId(specId);
        cart.setQuantity(quantity);

        if (!cartService.add(cart)) {
            throw new ServiceException("添加失败");
        }
        JsonUtil.writeSuccess(response, "添加成功", cartService.count(userId));
    }

    private void updateQuantity(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer userId = SessionUtil.currentUserId(request);
        int id = parseCartId(ApiRouter.pathVariable(request, "cartId"));

        String quantityStr = request.getParameter("quantity");
        int quantity;
        try {
            quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException e) {
            throw new ServiceException("数量格式错误");
        }

        // 归属校验：仅能修改自己的购物车项
        Cart cart = cartService.findById(id);
        if (cart == null || !cart.getUserId().equals(userId)) {
            throw new ServiceException("购物车项不存在");
        }
        if (!cartService.updateQuantity(id, quantity)) {
            throw new ServiceException("更新失败");
        }
        JsonUtil.writeSuccess(response, "更新成功");
    }

    private void remove(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer userId = SessionUtil.currentUserId(request);
        int id = parseCartId(ApiRouter.pathVariable(request, "cartId"));

        Cart cart = cartService.findById(id);
        if (cart == null || !cart.getUserId().equals(userId)) {
            throw new ServiceException("购物车项不存在");
        }
        if (!cartService.delete(id)) {
            throw new ServiceException("删除失败");
        }
        JsonUtil.writeSuccess(response, "删除成功");
    }

    private int parseCartId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new ServiceException("购物车ID格式错误");
        }
    }
}
