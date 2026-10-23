package com.example.cakeshop.dao;

import com.example.cakeshop.model.User;

import java.util.List;

/**
 * 用户数据访问接口
 */
public interface UserDao {

    int insert(User user);

    User findByUsername(String username);

    User findById(Integer id);

    int update(User user);

    int updatePassword(Integer id, String password);

    boolean existsByUsername(String username);

    List<User> findAll(int offset, int pageSize);

    int count();

    int updateStatus(Integer id, Integer status);
}
