package com.example.cakeshop.service.impl;

import com.example.cakeshop.dao.UserDao;
import com.example.cakeshop.dao.impl.UserDaoImpl;
import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.model.User;
import com.example.cakeshop.service.UserService;
import com.example.cakeshop.util.PasswordUtil;

import java.util.List;

/**
 * 用户业务实现：口令散列、账号状态与用户名唯一性都在这里收敛。
 */
public class UserServiceImpl implements UserService {

    private static final int MIN_PASSWORD_LENGTH = 6;
    private static final Integer DISABLED = 0;

    private final UserDao userDao = new UserDaoImpl();

    @Override
    public boolean register(User user) {
        String username = trimmed(user.getUsername());
        String password = user.getPassword();
        if (username.isEmpty()) {
            throw new ServiceException("用户名不能为空");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new ServiceException("密码不能为空");
        }
        if (password.length() < MIN_PASSWORD_LENGTH) {
            throw new ServiceException("密码长度不能少于6位");
        }
        if (userDao.existsByUsername(username)) {
            throw new ServiceException("用户名已存在");
        }
        user.setUsername(username);
        user.setPassword(PasswordUtil.encode(password));
        user.setStatus(1);
        if (user.getRole() == null) {
            user.setRole(0);
        }
        return userDao.insert(user) > 0;
    }

    @Override
    public User login(String username, String password) {
        User user = userDao.findByUsername(trimmed(username));
        if (user == null || !PasswordUtil.matches(password, user.getPassword())) {
            return null;
        }
        if (DISABLED.equals(user.getStatus())) {
            return null;
        }
        if (PasswordUtil.needsUpgrade(user.getPassword())) {
            userDao.updatePassword(user.getId(), PasswordUtil.encode(password));
        }
        user.setPassword(null);
        return user;
    }

    @Override
    public User findById(Integer id) {
        User user = userDao.findById(id);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    @Override
    public boolean update(User user) {
        return userDao.update(user) > 0;
    }

    @Override
    public boolean updatePassword(Integer id, String oldPassword, String newPassword) {
        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            throw new ServiceException("旧密码不能为空");
        }
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new ServiceException("新密码不能为空");
        }
        if (newPassword.length() < MIN_PASSWORD_LENGTH) {
            throw new ServiceException("新密码长度不能少于6位");
        }
        User user = userDao.findById(id);
        if (user == null || !PasswordUtil.matches(oldPassword, user.getPassword())) {
            throw new ServiceException("旧密码错误");
        }
        return userDao.updatePassword(id, PasswordUtil.encode(newPassword)) > 0;
    }

    @Override
    public List<User> findAll(int page, int pageSize) {
        List<User> users = userDao.findAll((page - 1) * pageSize, pageSize);
        for (User user : users) {
            user.setPassword(null);
        }
        return users;
    }

    @Override
    public int count() {
        return userDao.count();
    }

    @Override
    public boolean updateStatus(Integer id, Integer status) {
        return userDao.updateStatus(id, status) > 0;
    }

    private String trimmed(String value) {
        return value == null ? "" : value.trim();
    }
}
