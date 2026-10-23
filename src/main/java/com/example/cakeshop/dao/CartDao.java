package com.example.cakeshop.dao;

import com.example.cakeshop.model.Cart;

import java.util.List;

/**
 * 购物车数据访问接口
 */
public interface CartDao {

    int insert(Cart cart);

    List<Cart> findByUserId(Integer userId);

    Cart findById(Integer id);

    Cart findByProductAndSpec(Integer userId, Integer productId, Integer specId);

    int updateQuantity(Integer id, Integer quantity);

    int delete(Integer id);

    int deleteByUserId(Integer userId);

    int deleteByIds(List<Integer> ids);

    int countByUserId(Integer userId);
}
