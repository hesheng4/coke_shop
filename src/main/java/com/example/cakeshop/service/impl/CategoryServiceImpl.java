package com.example.cakeshop.service.impl;

import com.example.cakeshop.dao.CategoryDao;
import com.example.cakeshop.dao.impl.CategoryDaoImpl;
import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.model.Category;
import com.example.cakeshop.service.CategoryService;

import java.util.List;

/**
 * 分类业务实现：名称、父级、删除前置校验集中在此，校验失败统一抛 ServiceException。
 */
public class CategoryServiceImpl implements CategoryService {

    private static final Integer TOP_LEVEL = 0;
    private static final Integer DEFAULT_SORT = 0;
    private static final Integer ENABLED = 1;

    private final CategoryDao categoryDao = new CategoryDaoImpl();

    @Override
    public List<Category> findAll() {
        return categoryDao.findAll();
    }

    @Override
    public List<Category> findAllAdmin() {
        return categoryDao.findAllAdmin();
    }

    @Override
    public List<Category> findTopLevel() {
        return categoryDao.findTopLevel();
    }

    @Override
    public List<Category> findByParentId(Integer parentId) {
        return categoryDao.findByParentId(parentId);
    }

    @Override
    public Category findById(Integer id) {
        return categoryDao.findById(id);
    }

    @Override
    public List<Category> findTree() {
        return categoryDao.findTree();
    }

    @Override
    public List<Category> findTreeWithProductCount() {
        return categoryDao.findTreeWithProductCount();
    }

    @Override
    public boolean add(Category category) {
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new ServiceException("分类名称不能为空");
        }
        if (category.getParentId() != null && category.getParentId() > 0) {
            Category parent = categoryDao.findById(category.getParentId());
            if (parent == null) {
                throw new ServiceException("父分类不存在");
            }
        } else {
            category.setParentId(TOP_LEVEL);
        }
        if (category.getSortOrder() == null) category.setSortOrder(DEFAULT_SORT);
        if (category.getStatus() == null) category.setStatus(ENABLED);

        return categoryDao.insert(category) > 0;
    }

    @Override
    public boolean update(Category category) {
        if (category.getId() == null) {
            throw new ServiceException("分类ID不能为空");
        }
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new ServiceException("分类名称不能为空");
        }
        if (category.getParentId() != null && category.getParentId().equals(category.getId())) {
            throw new ServiceException("不能将自己设为父分类");
        }
        if (category.getParentId() != null && category.getParentId() > 0) {
            Category parent = categoryDao.findById(category.getParentId());
            if (parent == null) {
                throw new ServiceException("父分类不存在");
            }
        } else {
            category.setParentId(TOP_LEVEL);
        }
        return categoryDao.update(category) > 0;
    }

    @Override
    public boolean delete(Integer id) {
        if (id == null) {
            throw new ServiceException("分类ID不能为空");
        }
        Category category = categoryDao.findById(id);
        if (category == null) {
            throw new ServiceException("分类不存在");
        }
        int childCount = categoryDao.countChildren(id);
        if (childCount > 0) {
            throw new ServiceException("该分类下还有 " + childCount + " 个子分类，无法删除");
        }
        int productCount = categoryDao.countProducts(id);
        if (productCount > 0) {
            throw new ServiceException("该分类下还有 " + productCount + " 个商品，无法删除");
        }
        return categoryDao.delete(id) > 0;
    }

    @Override
    public boolean updateStatus(Integer id, Integer status) {
        return categoryDao.updateStatus(id, status) > 0;
    }
}
