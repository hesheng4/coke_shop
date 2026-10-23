package com.example.cakeshop.service;

import com.example.cakeshop.model.User;

import java.util.List;

/**
 * 用户业务逻辑接口
 */
public interface UserService {

    boolean register(User user);

    User login(String username, String password);

    User findById(Integer id);

    boolean update(User user);

    boolean updatePassword(Integer id, String oldPassword, String newPassword);

    List<User> findAll(int page, int pageSize);

    int count();

    boolean updateStatus(Integer id, Integer status);
}
