package com.example.cakeshop.service;

import com.example.cakeshop.model.Category;

import java.util.List;

/**
 * 分类业务逻辑接口
 */
public interface CategoryService {

    List<Category> findAll();

    List<Category> findAllAdmin();

    List<Category> findTopLevel();

    List<Category> findByParentId(Integer parentId);

    Category findById(Integer id);

    List<Category> findTree();

    List<Category> findTreeWithProductCount();

    boolean add(Category category);

    boolean update(Category category);

    boolean delete(Integer id);

    boolean updateStatus(Integer id, Integer status);
}
