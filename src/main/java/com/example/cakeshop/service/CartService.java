package com.example.cakeshop.service;

import com.example.cakeshop.model.Cart;

import java.util.List;

/**
 * 购物车业务逻辑接口
 */
public interface CartService {

    boolean add(Cart cart);

    List<Cart> findByUserId(Integer userId);

    Cart findById(Integer id);

    boolean updateQuantity(Integer id, Integer quantity);

    boolean delete(Integer id);

    boolean deleteByIds(List<Integer> ids);

    boolean clear(Integer userId);

    int count(Integer userId);
}
