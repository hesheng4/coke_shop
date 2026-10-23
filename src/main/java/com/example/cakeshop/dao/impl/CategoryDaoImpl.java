package com.example.cakeshop.dao.impl;

import com.example.cakeshop.dao.CategoryDao;
import com.example.cakeshop.dao.JdbcTemplate;
import com.example.cakeshop.model.Category;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 基于 JDBC 模板的分类数据访问实现。
 */
public class CategoryDaoImpl implements CategoryDao {

    private static final Integer ENABLED = 1;
    private static final Integer TOP_LEVEL = 0;

    private static final String SELECT_ALL = "SELECT * FROM category WHERE status = 1 ORDER BY sort_order ASC";
    private static final String SELECT_ALL_ADMIN = "SELECT * FROM category ORDER BY sort_order ASC, id ASC";
    private static final String SELECT_TOP_LEVEL =
            "SELECT * FROM category WHERE parent_id = 0 AND status = 1 ORDER BY sort_order ASC";
    private static final String SELECT_BY_PARENT =
            "SELECT * FROM category WHERE parent_id = ? AND status = 1 ORDER BY sort_order ASC";
    private static final String SELECT_BY_ID = "SELECT * FROM category WHERE id = ?";
    private static final String SELECT_TREE_WITH_COUNT =
            "SELECT c.*, COUNT(p.id) AS product_count " +
                    "FROM category c " +
                    "LEFT JOIN product p ON p.category_id = c.id AND p.status = 1 " +
                    "WHERE c.status = 1 " +
                    "GROUP BY c.id " +
                    "ORDER BY c.sort_order ASC, c.id ASC";
    private static final String COUNT_CHILDREN = "SELECT COUNT(*) FROM category WHERE parent_id = ?";
    private static final String COUNT_PRODUCTS = "SELECT COUNT(*) FROM product WHERE category_id = ?";
    private static final String INSERT_SQL =
            "INSERT INTO category (name, parent_id, sort_order, status) VALUES (?, ?, ?, ?)";
    private static final String UPDATE_SQL =
            "UPDATE category SET name = ?, parent_id = ?, sort_order = ?, status = ? WHERE id = ?";
    private static final String DELETE_SQL = "DELETE FROM category WHERE id = ?";
    private static final String UPDATE_STATUS = "UPDATE category SET status = ? WHERE id = ?";

    @Override
    public List<Category> findAll() {
        return JdbcTemplate.query(SELECT_ALL, this::mapRow);
    }

    @Override
    public List<Category> findAllAdmin() {
        return JdbcTemplate.query(SELECT_ALL_ADMIN, this::mapRow);
    }

    @Override
    public List<Category> findTopLevel() {
        return JdbcTemplate.query(SELECT_TOP_LEVEL, this::mapRow);
    }

    @Override
    public List<Category> findByParentId(Integer parentId) {
        return JdbcTemplate.query(SELECT_BY_PARENT, this::mapRow, parentId);
    }

    @Override
    public Category findById(Integer id) {
        return JdbcTemplate.queryFirst(SELECT_BY_ID, this::mapRow, id);
    }

    @Override
    public List<Category> findTree() {
        return buildTree(findAll());
    }

    @Override
    public List<Category> findTreeWithProductCount() {
        List<Category> all = JdbcTemplate.query(SELECT_TREE_WITH_COUNT, rs -> {
            Category category = mapRow(rs);
            category.setProductCount(rs.getInt("product_count"));
            return category;
        });
        return buildTree(all);
    }

    @Override
    public int countChildren(Integer parentId) {
        Integer count = JdbcTemplate.queryScalar(COUNT_CHILDREN, Integer.class, parentId);
        return count == null ? 0 : count;
    }

    @Override
    public int countProducts(Integer categoryId) {
        Integer count = JdbcTemplate.queryScalar(COUNT_PRODUCTS, Integer.class, categoryId);
        return count == null ? 0 : count;
    }

    @Override
    public int insert(Category category) {
        return JdbcTemplate.insert(INSERT_SQL,
                category.getName(),
                category.getParentId() != null ? category.getParentId() : TOP_LEVEL,
                category.getSortOrder() != null ? category.getSortOrder() : 0,
                category.getStatus() != null ? category.getStatus() : ENABLED);
    }

    @Override
    public int update(Category category) {
        return JdbcTemplate.update(UPDATE_SQL,
                category.getName(),
                category.getParentId() != null ? category.getParentId() : TOP_LEVEL,
                category.getSortOrder() != null ? category.getSortOrder() : 0,
                category.getStatus() != null ? category.getStatus() : ENABLED,
                category.getId());
    }

    @Override
    public int delete(Integer id) {
        return JdbcTemplate.update(DELETE_SQL, id);
    }

    @Override
    public int updateStatus(Integer id, Integer status) {
        return JdbcTemplate.update(UPDATE_STATUS, status, id);
    }

    private List<Category> buildTree(List<Category> all) {
        List<Category> roots = new ArrayList<>();
        for (Category c : all) {
            if (c.getParentId() == null || c.getParentId() == 0) {
                roots.add(c);
            }
        }
        for (Category root : roots) {
            root.setChildren(findChildren(root.getId(), all));
        }
        return roots;
    }

    private List<Category> findChildren(Integer parentId, List<Category> all) {
        List<Category> children = new ArrayList<>();
        for (Category c : all) {
            if (parentId.equals(c.getParentId())) {
                children.add(c);
                c.setChildren(findChildren(c.getId(), all));
            }
        }
        return children;
    }

    private Category mapRow(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        category.setParentId(rs.getInt("parent_id"));
        category.setSortOrder(rs.getInt("sort_order"));
        category.setStatus(rs.getInt("status"));
        category.setCreateTime(rs.getTimestamp("create_time"));
        return category;
    }
}
