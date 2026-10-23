package com.example.cakeshop.dao.impl;

import com.example.cakeshop.dao.CartDao;
import com.example.cakeshop.dao.JdbcTemplate;
import com.example.cakeshop.model.Cart;
import com.example.cakeshop.model.Product;
import com.example.cakeshop.model.ProductSpec;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 基于 JDBC 模板的购物车数据访问实现
 */
public class CartDaoImpl implements CartDao {

    private static final Logger log = Logger.getLogger(CartDaoImpl.class.getName());

    private static final String INSERT_SQL =
            "INSERT INTO cart (user_id, product_id, spec_id, quantity) VALUES (?, ?, ?, ?)";
    private static final String SELECT_WITH_PRODUCT =
            "SELECT c.*, p.name as product_name, p.price as product_price, p.image as product_image, " +
                    "ps.spec_name, ps.spec_value, ps.price as spec_price " +
                    "FROM cart c " +
                    "LEFT JOIN product p ON c.product_id = p.id " +
                    "LEFT JOIN product_spec ps ON c.spec_id = ps.id ";
    private static final String SELECT_BY_USER_ID = SELECT_WITH_PRODUCT + "WHERE c.user_id = ? ORDER BY c.create_time DESC";
    private static final String SELECT_BY_ID = SELECT_WITH_PRODUCT + "WHERE c.id = ?";
    private static final String SELECT_BY_PRODUCT_SPEC = "SELECT * FROM cart WHERE user_id = ? AND product_id = ?";
    private static final String SELECT_BY_PRODUCT_SPEC_NO_SPEC = SELECT_BY_PRODUCT_SPEC + " AND spec_id IS NULL";
    private static final String SELECT_BY_PRODUCT_SPEC_WITH_SPEC = SELECT_BY_PRODUCT_SPEC + " AND spec_id = ?";
    private static final String UPDATE_QUANTITY = "UPDATE cart SET quantity = ? WHERE id = ?";
    private static final String DELETE_BY_ID = "DELETE FROM cart WHERE id = ?";
    private static final String DELETE_BY_USER_ID = "DELETE FROM cart WHERE user_id = ?";
    private static final String COUNT_BY_USER_ID = "SELECT COALESCE(SUM(quantity), 0) FROM cart WHERE user_id = ?";

    @Override
    public int insert(Cart cart) {
        return JdbcTemplate.insert(INSERT_SQL,
                cart.getUserId(),
                cart.getProductId(),
                cart.getSpecId(),
                cart.getQuantity());
    }

    @Override
    public List<Cart> findByUserId(Integer userId) {
        return JdbcTemplate.query(SELECT_BY_USER_ID, this::mapRow, userId);
    }

    @Override
    public Cart findById(Integer id) {
        return JdbcTemplate.queryFirst(SELECT_BY_ID, this::mapRow, id);
    }

    @Override
    public Cart findByProductAndSpec(Integer userId, Integer productId, Integer specId) {
        if (specId == null) {
            return JdbcTemplate.queryFirst(SELECT_BY_PRODUCT_SPEC_NO_SPEC, this::mapCartOnly, userId, productId);
        }
        return JdbcTemplate.queryFirst(SELECT_BY_PRODUCT_SPEC_WITH_SPEC, this::mapCartOnly, userId, productId, specId);
    }

    @Override
    public int updateQuantity(Integer id, Integer quantity) {
        return JdbcTemplate.update(UPDATE_QUANTITY, quantity, id);
    }

    @Override
    public int delete(Integer id) {
        return JdbcTemplate.update(DELETE_BY_ID, id);
    }

    @Override
    public int deleteByUserId(Integer userId) {
        return JdbcTemplate.update(DELETE_BY_USER_ID, userId);
    }

    @Override
    public int deleteByIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return 0;
        }
        StringBuilder sql = new StringBuilder("DELETE FROM cart WHERE id IN (");
        Object[] params = new Object[ids.size()];
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) {
                sql.append(",");
            }
            sql.append("?");
            params[i] = ids.get(i);
        }
        sql.append(")");
        return JdbcTemplate.update(sql.toString(), params);
    }

    @Override
    public int countByUserId(Integer userId) {
        Integer count = JdbcTemplate.queryScalar(COUNT_BY_USER_ID, Integer.class, userId);
        return count == null ? 0 : count;
    }

    /**
     * cart 表自身的字段映射，供不含商品关联列的查询使用
     */
    private Cart mapCartOnly(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setId(rs.getInt("id"));
        cart.setUserId(rs.getInt("user_id"));
        cart.setProductId(rs.getInt("product_id"));
        cart.setSpecId(rs.getObject("spec_id") != null ? rs.getInt("spec_id") : null);
        cart.setQuantity(rs.getInt("quantity"));
        cart.setCreateTime(rs.getTimestamp("create_time"));
        cart.setUpdateTime(rs.getTimestamp("update_time"));
        return cart;
    }

    private Cart mapRow(ResultSet rs) throws SQLException {
        Cart cart = mapCartOnly(rs);

        // 商品与规格来自 LEFT JOIN，关联列缺失时只记录告警、不阻断列表返回
        try {
            String productName = rs.getString("product_name");
            if (productName != null) {
                Product product = new Product();
                product.setId(cart.getProductId());
                product.setName(productName);
                product.setPrice(rs.getBigDecimal("product_price"));
                product.setImage(rs.getString("product_image"));
                cart.setProduct(product);
            }
        } catch (SQLException e) {
            log.log(Level.WARNING, "购物车商品关联信息读取失败, cartId=" + cart.getId(), e);
        }

        try {
            String specName = rs.getString("spec_name");
            if (specName != null) {
                ProductSpec spec = new ProductSpec();
                spec.setId(cart.getSpecId());
                spec.setSpecName(specName);
                spec.setSpecValue(rs.getString("spec_value"));
                spec.setPrice(rs.getBigDecimal("spec_price"));
                cart.setSpec(spec);
            }
        } catch (SQLException e) {
            log.log(Level.WARNING, "购物车规格关联信息读取失败, cartId=" + cart.getId(), e);
        }

        if (cart.getProduct() != null) {
            BigDecimal price = cart.getProduct().getPrice();
            if (cart.getSpec() != null && cart.getSpec().getPrice() != null) {
                price = cart.getSpec().getPrice();
            }
            cart.setTotalPrice(price.multiply(new BigDecimal(cart.getQuantity())));
        }

        return cart;
    }
}
