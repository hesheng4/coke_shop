package com.example.cakeshop.dao.impl;

import com.example.cakeshop.dao.AddressDao;
import com.example.cakeshop.dao.JdbcTemplate;
import com.example.cakeshop.model.Address;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * 基于 JDBC 模板的收货地址数据访问实现
 */
public class AddressDaoImpl implements AddressDao {

    private static final String INSERT_SQL = "INSERT INTO address (user_id, receiver_name, receiver_phone, province, "
            + "city, district, detail_address, is_default) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_BY_USER = "SELECT * FROM address WHERE user_id = ? ORDER BY is_default DESC, create_time DESC";
    private static final String SELECT_BY_ID = "SELECT * FROM address WHERE id = ?";
    private static final String SELECT_DEFAULT = "SELECT * FROM address WHERE user_id = ? AND is_default = 1";
    private static final String UPDATE_SQL = "UPDATE address SET receiver_name = ?, receiver_phone = ?, province = ?, "
            + "city = ?, district = ?, detail_address = ?, is_default = ? WHERE id = ?";
    private static final String DELETE_SQL = "DELETE FROM address WHERE id = ?";
    private static final String CLEAR_DEFAULT = "UPDATE address SET is_default = 0 WHERE user_id = ?";
    private static final String MARK_DEFAULT = "UPDATE address SET is_default = 1 WHERE id = ?";

    @Override
    public int insert(Address address) {
        return JdbcTemplate.insert(INSERT_SQL,
                address.getUserId(),
                address.getReceiverName(),
                address.getReceiverPhone(),
                address.getProvince(),
                address.getCity(),
                address.getDistrict(),
                address.getDetailAddress(),
                address.getIsDefault() != null ? address.getIsDefault() : 0);
    }

    @Override
    public List<Address> findByUserId(Integer userId) {
        return JdbcTemplate.query(SELECT_BY_USER, this::mapRow, userId);
    }

    @Override
    public Address findById(Integer id) {
        return JdbcTemplate.queryFirst(SELECT_BY_ID, this::mapRow, id);
    }

    @Override
    public Address findDefault(Integer userId) {
        return JdbcTemplate.queryFirst(SELECT_DEFAULT, this::mapRow, userId);
    }

    @Override
    public int update(Address address) {
        return JdbcTemplate.update(UPDATE_SQL,
                address.getReceiverName(),
                address.getReceiverPhone(),
                address.getProvince(),
                address.getCity(),
                address.getDistrict(),
                address.getDetailAddress(),
                address.getIsDefault(),
                address.getId());
    }

    @Override
    public int delete(Integer id) {
        return JdbcTemplate.update(DELETE_SQL, id);
    }

    @Override
    public int clearDefault(Integer userId) {
        return JdbcTemplate.update(CLEAR_DEFAULT, userId);
    }

    @Override
    public int markDefault(Integer id) {
        return JdbcTemplate.update(MARK_DEFAULT, id);
    }

    private Address mapRow(ResultSet rs) throws SQLException {
        Address address = new Address();
        address.setId(rs.getInt("id"));
        address.setUserId(rs.getInt("user_id"));
        address.setReceiverName(rs.getString("receiver_name"));
        address.setReceiverPhone(rs.getString("receiver_phone"));
        address.setProvince(rs.getString("province"));
        address.setCity(rs.getString("city"));
        address.setDistrict(rs.getString("district"));
        address.setDetailAddress(rs.getString("detail_address"));
        address.setIsDefault(rs.getInt("is_default"));
        address.setCreateTime(rs.getTimestamp("create_time"));
        address.setUpdateTime(rs.getTimestamp("update_time"));
        return address;
    }
}
