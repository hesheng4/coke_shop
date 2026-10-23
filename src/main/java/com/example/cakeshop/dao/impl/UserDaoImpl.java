package com.example.cakeshop.dao.impl;

import com.example.cakeshop.dao.JdbcTemplate;
import com.example.cakeshop.dao.UserDao;
import com.example.cakeshop.model.User;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * 基于 JDBC 模板的用户数据访问实现
 */
public class UserDaoImpl implements UserDao {

    private static final String INSERT_SQL =
            "INSERT INTO user (username, password, email, phone, avatar, status, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_BY_USERNAME = "SELECT * FROM user WHERE username = ?";
    private static final String SELECT_BY_ID = "SELECT * FROM user WHERE id = ?";
    private static final String UPDATE_PROFILE = "UPDATE user SET email = ?, phone = ?, avatar = ? WHERE id = ?";
    private static final String UPDATE_PASSWORD = "UPDATE user SET password = ? WHERE id = ?";
    private static final String EXISTS_BY_USERNAME = "SELECT COUNT(*) FROM user WHERE username = ?";
    private static final String SELECT_PAGE = "SELECT * FROM user ORDER BY create_time DESC LIMIT ?, ?";
    private static final String COUNT_ALL = "SELECT COUNT(*) FROM user";
    private static final String UPDATE_STATUS = "UPDATE user SET status = ? WHERE id = ?";

    @Override
    public int insert(User user) {
        return JdbcTemplate.insert(INSERT_SQL,
                user.getUsername(),
                user.getPassword(),
                user.getEmail(),
                user.getPhone(),
                user.getAvatar(),
                user.getStatus() != null ? user.getStatus() : 1,
                user.getRole() != null ? user.getRole() : 0);
    }

    @Override
    public User findByUsername(String username) {
        return JdbcTemplate.queryFirst(SELECT_BY_USERNAME, this::mapRow, username);
    }

    @Override
    public User findById(Integer id) {
        return JdbcTemplate.queryFirst(SELECT_BY_ID, this::mapRow, id);
    }

    @Override
    public int update(User user) {
        return JdbcTemplate.update(UPDATE_PROFILE, user.getEmail(), user.getPhone(), user.getAvatar(), user.getId());
    }

    @Override
    public int updatePassword(Integer id, String password) {
        return JdbcTemplate.update(UPDATE_PASSWORD, password, id);
    }

    @Override
    public boolean existsByUsername(String username) {
        Integer count = JdbcTemplate.queryScalar(EXISTS_BY_USERNAME, Integer.class, username);
        return count != null && count > 0;
    }

    @Override
    public List<User> findAll(int offset, int pageSize) {
        return JdbcTemplate.query(SELECT_PAGE, this::mapRow, offset, pageSize);
    }

    @Override
    public int count() {
        Integer count = JdbcTemplate.queryScalar(COUNT_ALL, Integer.class);
        return count == null ? 0 : count;
    }

    @Override
    public int updateStatus(Integer id, Integer status) {
        return JdbcTemplate.update(UPDATE_STATUS, status, id);
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setAvatar(rs.getString("avatar"));
        user.setStatus(rs.getInt("status"));
        user.setRole(rs.getInt("role"));
        user.setCreateTime(rs.getTimestamp("create_time"));
        user.setUpdateTime(rs.getTimestamp("update_time"));
        return user;
    }
}
