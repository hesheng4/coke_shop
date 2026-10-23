package com.example.cakeshop.service.impl;

import com.example.cakeshop.dao.CartDao;
import com.example.cakeshop.dao.impl.CartDaoImpl;
import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.model.Cart;
import com.example.cakeshop.service.CartService;
import com.example.cakeshop.tx.TransactionManager;

import java.util.List;

/**
 * 购物车业务实现：重复商品累加数量，写入与查重要在同一事务内完成。
 */
public class CartServiceImpl implements CartService {

    private final CartDao cartDao = new CartDaoImpl();

    @Override
    public boolean add(Cart cart) {
        if (cart.getQuantity() == null || cart.getQuantity() <= 0) {
            throw new ServiceException("数量不合法");
        }
        return Boolean.TRUE.equals(TransactionManager.execute(context -> {
            Cart existing = cartDao.findByProductAndSpec(cart.getUserId(), cart.getProductId(), cart.getSpecId());
            if (existing != null) {
                // 沿用老行为：同商品同规格累加数量而非新增行
                return cartDao.updateQuantity(existing.getId(), existing.getQuantity() + cart.getQuantity()) > 0;
            }
            return cartDao.insert(cart) > 0;
        }));
    }

    @Override
    public List<Cart> findByUserId(Integer userId) {
        return cartDao.findByUserId(userId);
    }

    @Override
    public Cart findById(Integer id) {
        return cartDao.findById(id);
    }

    @Override
    public boolean updateQuantity(Integer id, Integer quantity) {
        if (quantity == null) {
            throw new ServiceException("数量不合法");
        }
        if (quantity <= 0) {
            // 沿用老行为：数量为 0 或负数时直接删除该购物车项
            return delete(id);
        }
        return cartDao.updateQuantity(id, quantity) > 0;
    }

    @Override
    public boolean delete(Integer id) {
        return cartDao.delete(id) > 0;
    }

    @Override
    public boolean deleteByIds(List<Integer> ids) {
        return cartDao.deleteByIds(ids) > 0;
    }

    @Override
    public boolean clear(Integer userId) {
        return cartDao.deleteByUserId(userId) > 0;
    }

    @Override
    public int count(Integer userId) {
        return cartDao.countByUserId(userId);
    }
}
