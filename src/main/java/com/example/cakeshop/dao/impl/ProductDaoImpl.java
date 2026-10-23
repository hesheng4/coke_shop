package com.example.cakeshop.dao.impl;

import com.example.cakeshop.dao.JdbcTemplate;
import com.example.cakeshop.dao.ProductDao;
import com.example.cakeshop.model.Product;
import com.example.cakeshop.model.ProductSpec;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 基于 JDBC 模板的商品数据访问实现。
 */
public class ProductDaoImpl implements ProductDao {

    private static final Logger log = Logger.getLogger(ProductDaoImpl.class.getName());

    private static final Integer ON_SALE = 1;

    // 修复：原 insert/update 遗漏了 images 列，这里补齐读写
    private static final String INSERT_SQL =
            "INSERT INTO product (name, category_id, price, original_price, stock, image, images, description, detail, status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_SQL =
            "UPDATE product SET name = ?, category_id = ?, price = ?, original_price = ?, stock = ?, image = ?, images = ?, "
                    + "description = ?, detail = ? WHERE id = ?";
    private static final String SELECT_BY_ID =
            "SELECT p.*, c.name as category_name FROM product p LEFT JOIN category c ON p.category_id = c.id WHERE p.id = ?";
    private static final String SELECT_HOT =
            "SELECT p.*, c.name as category_name FROM product p LEFT JOIN category c ON p.category_id = c.id "
                    + "WHERE p.status = 1 ORDER BY p.sales DESC LIMIT ?";
    private static final String SELECT_NEW =
            "SELECT p.*, c.name as category_name FROM product p LEFT JOIN category c ON p.category_id = c.id "
                    + "WHERE p.status = 1 ORDER BY p.create_time DESC LIMIT ?";
    private static final String UPDATE_SALES = "UPDATE product SET sales = sales + ? WHERE id = ?";
    private static final String DELETE_BY_ID = "DELETE FROM product WHERE id = ?";
    private static final String UPDATE_STATUS = "UPDATE product SET status = ? WHERE id = ?";
    private static final String UPDATE_STOCK = "UPDATE product SET stock = stock - ? WHERE id = ? AND stock >= ?";
    private static final String SELECT_SPECS = "SELECT * FROM product_spec WHERE product_id = ?";
    private static final String SELECT_SPEC_BY_ID = "SELECT * FROM product_spec WHERE id = ?";
    private static final String UPDATE_SPEC_STOCK = "UPDATE product_spec SET stock = stock - ? WHERE id = ? AND stock >= ?";
    private static final String RESTORE_SPEC_STOCK = "UPDATE product_spec SET stock = stock + ? WHERE id = ?";
    private static final String RESTORE_STOCK = "UPDATE product SET stock = stock + ? WHERE id = ?";
    private static final String RESTORE_SALES = "UPDATE product SET sales = sales - ? WHERE id = ?";

    @Override
    public List<Product> findAll(Integer categoryId, String keyword, String orderBy, int offset, int pageSize) {
        List<Object> params = new ArrayList<>();
        String sql = buildListSql(false, categoryId, keyword, orderBy, offset, pageSize, params);
        return JdbcTemplate.query(sql, this::mapRow, params.toArray());
    }

    @Override
    public int count(Integer categoryId, String keyword) {
        List<Object> params = new ArrayList<>();
        String sql = buildCountSql(false, categoryId, keyword, params);
        Integer count = JdbcTemplate.queryScalar(sql, Integer.class, params.toArray());
        return count == null ? 0 : count;
    }

    @Override
    public List<Product> findAllAdmin(Integer categoryId, String keyword, String orderBy, int offset, int pageSize) {
        List<Object> params = new ArrayList<>();
        String sql = buildListSql(true, categoryId, keyword, orderBy, offset, pageSize, params);
        return JdbcTemplate.query(sql, this::mapRow, params.toArray());
    }

    @Override
    public int countAdmin(Integer categoryId, String keyword) {
        List<Object> params = new ArrayList<>();
        String sql = buildCountSql(true, categoryId, keyword, params);
        Integer count = JdbcTemplate.queryScalar(sql, Integer.class, params.toArray());
        return count == null ? 0 : count;
    }

    @Override
    public Product findById(Integer id) {
        return JdbcTemplate.queryFirst(SELECT_BY_ID, this::mapRow, id);
    }

    @Override
    public List<Product> findHotSales(int limit) {
        return JdbcTemplate.query(SELECT_HOT, this::mapRow, limit);
    }

    @Override
    public List<Product> findNewProducts(int limit) {
        return JdbcTemplate.query(SELECT_NEW, this::mapRow, limit);
    }

    @Override
    public int updateSales(Integer id, int quantity) {
        return JdbcTemplate.update(UPDATE_SALES, quantity, id);
    }

    @Override
    public int insert(Product product) {
        return JdbcTemplate.insert(INSERT_SQL,
                product.getName(),
                product.getCategoryId(),
                product.getPrice(),
                product.getOriginalPrice(),
                product.getStock() != null ? product.getStock() : 0,
                product.getImage(),
                product.getImages(),
                product.getDescription(),
                product.getDetail(),
                product.getStatus() != null ? product.getStatus() : ON_SALE);
    }

    @Override
    public int delete(Integer id) {
        return JdbcTemplate.update(DELETE_BY_ID, id);
    }

    @Override
    public int update(Product product) {
        return JdbcTemplate.update(UPDATE_SQL,
                product.getName(),
                product.getCategoryId(),
                product.getPrice(),
                product.getOriginalPrice(),
                product.getStock(),
                product.getImage(),
                product.getImages(),
                product.getDescription(),
                product.getDetail(),
                product.getId());
    }

    @Override
    public int updateStatus(Integer id, Integer status) {
        return JdbcTemplate.update(UPDATE_STATUS, status, id);
    }

    @Override
    public int updateStock(Integer id, int quantity) {
        return JdbcTemplate.update(UPDATE_STOCK, quantity, id, quantity);
    }

    @Override
    public List<ProductSpec> findSpecs(Integer productId) {
        return JdbcTemplate.query(SELECT_SPECS, this::mapSpec, productId);
    }

    @Override
    public Map<Integer, List<ProductSpec>> findSpecsByProductIds(List<Integer> productIds) {
        Map<Integer, List<ProductSpec>> grouped = new HashMap<>();
        if (productIds == null || productIds.isEmpty()) {
            return grouped;
        }
        // 值仍走参数绑定，仅占位符按数量拼接，避免逐商品查询的 N+1
        StringBuilder placeholders = new StringBuilder();
        Object[] params = productIds.toArray();
        for (int i = 0; i < params.length; i++) {
            placeholders.append(i == 0 ? "?" : ", ?");
        }
        String sql = "SELECT * FROM product_spec WHERE product_id IN (" + placeholders + ") ORDER BY product_id, id";
        List<ProductSpec> specs = JdbcTemplate.query(sql, this::mapSpec, params);
        for (ProductSpec spec : specs) {
            grouped.computeIfAbsent(spec.getProductId(), k -> new ArrayList<>()).add(spec);
        }
        return grouped;
    }

    @Override
    public int updateSpecStock(Integer specId, int quantity) {
        return JdbcTemplate.update(UPDATE_SPEC_STOCK, quantity, specId, quantity);
    }

    @Override
    public int restoreSpecStock(Integer specId, int quantity) {
        return JdbcTemplate.update(RESTORE_SPEC_STOCK, quantity, specId);
    }

    @Override
    public int restoreStock(Integer id, int quantity) {
        return JdbcTemplate.update(RESTORE_STOCK, quantity, id);
    }

    @Override
    public int restoreSales(Integer id, int quantity) {
        return JdbcTemplate.update(RESTORE_SALES, quantity, id);
    }

    @Override
    public ProductSpec findSpecById(Integer id) {
        return JdbcTemplate.queryFirst(SELECT_SPEC_BY_ID, this::mapSpec, id);
    }

    private String buildListSql(boolean admin, Integer categoryId, String keyword, String orderBy,
                                int offset, int pageSize, List<Object> params) {
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.name as category_name FROM product p LEFT JOIN category c ON p.category_id = c.id WHERE ");
        sql.append(admin ? "1=1" : "p.status = 1");
        appendCategoryFilter(sql, categoryId, params);
        appendKeywordFilter(sql, keyword, params);
        sql.append(chooseOrderBy(orderBy));
        sql.append(" LIMIT ?, ?");
        params.add(offset);
        params.add(pageSize);
        return sql.toString();
    }

    private String buildCountSql(boolean admin, Integer categoryId, String keyword, List<Object> params) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM product WHERE ");
        sql.append(admin ? "1=1" : "status = 1");
        appendCountCategoryFilter(sql, categoryId, params);
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        return sql.toString();
    }

    private void appendCategoryFilter(StringBuilder sql, Integer categoryId, List<Object> params) {
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND (p.category_id = ? OR p.category_id IN (SELECT id FROM category WHERE parent_id = ?))");
            params.add(categoryId);
            params.add(categoryId);
        }
    }

    private void appendKeywordFilter(StringBuilder sql, String keyword, List<Object> params) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.description LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
    }

    private void appendCountCategoryFilter(StringBuilder sql, Integer categoryId, List<Object> params) {
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND (category_id = ? OR category_id IN (SELECT id FROM category WHERE parent_id = ?))");
            params.add(categoryId);
            params.add(categoryId);
        }
    }

    // 排序白名单，保持与老代码一致，杜绝 SQL 注入
    private String chooseOrderBy(String orderBy) {
        if ("price_asc".equals(orderBy)) {
            return " ORDER BY p.price ASC";
        } else if ("price_desc".equals(orderBy)) {
            return " ORDER BY p.price DESC";
        } else if ("sales".equals(orderBy)) {
            return " ORDER BY p.sales DESC";
        } else if ("id_asc".equals(orderBy)) {
            return " ORDER BY p.id ASC";
        } else if ("id_desc".equals(orderBy)) {
            return " ORDER BY p.id DESC";
        } else {
            return " ORDER BY p.create_time DESC";
        }
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setOriginalPrice(rs.getBigDecimal("original_price"));
        product.setStock(rs.getInt("stock"));
        product.setSales(rs.getInt("sales"));
        product.setImage(rs.getString("image"));
        product.setImages(rs.getString("images"));
        product.setDescription(rs.getString("description"));
        product.setDetail(rs.getString("detail"));
        product.setStatus(rs.getInt("status"));
        product.setCreateTime(rs.getTimestamp("create_time"));
        product.setUpdateTime(rs.getTimestamp("update_time"));
        try {
            product.setCategoryName(rs.getString("category_name"));
        } catch (SQLException e) {
            // 部分查询（如规格关联）不含 category_name，降级为可空字段并记录
            log.log(Level.FINE, "结果集缺少 category_name 列，已跳过", e);
        }
        return product;
    }

    private ProductSpec mapSpec(ResultSet rs) throws SQLException {
        ProductSpec spec = new ProductSpec();
        spec.setId(rs.getInt("id"));
        spec.setProductId(rs.getInt("product_id"));
        spec.setSpecName(rs.getString("spec_name"));
        spec.setSpecValue(rs.getString("spec_value"));
        spec.setPrice(rs.getBigDecimal("price"));
        spec.setStock(rs.getInt("stock"));
        spec.setCreateTime(rs.getTimestamp("create_time"));
        return spec;
    }
}
