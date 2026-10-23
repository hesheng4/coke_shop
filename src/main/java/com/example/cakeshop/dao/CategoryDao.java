package com.example.cakeshop.dao;

import com.example.cakeshop.model.Category;

import java.util.List;

/**
 * 分类数据访问接口
 */
public interface CategoryDao {

    List<Category> findAll();

    List<Category> findAllAdmin();

    List<Category> findTopLevel();

    List<Category> findByParentId(Integer parentId);

    Category findById(Integer id);

    List<Category> findTree();

    List<Category> findTreeWithProductCount();

    int countChildren(Integer parentId);

    int countProducts(Integer categoryId);

    int insert(Category category);

    int update(Category category);

    int delete(Integer id);

    int updateStatus(Integer id, Integer status);
}
