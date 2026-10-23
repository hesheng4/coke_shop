package com.example.cakeshop.service.impl;

import com.example.cakeshop.dao.ProductDao;
import com.example.cakeshop.dao.impl.ProductDaoImpl;
import com.example.cakeshop.model.Product;
import com.example.cakeshop.model.ProductSpec;
import com.example.cakeshop.service.ProductService;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * 商品业务实现：批量补全规格，消除逐商品查询的 N+1。
 */
public class ProductServiceImpl implements ProductService {

    private final ProductDao productDao = new ProductDaoImpl();

    @Override
    public List<Product> findAll(Integer categoryId, String keyword, String orderBy, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        List<Product> products = productDao.findAll(categoryId, keyword, orderBy, offset, pageSize);
        attachSpecs(products);
        return products;
    }

    @Override
    public int count(Integer categoryId, String keyword) {
        return productDao.count(categoryId, keyword);
    }

    @Override
    public List<Product> findAllAdmin(Integer categoryId, String keyword, String orderBy, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        List<Product> products = productDao.findAllAdmin(categoryId, keyword, orderBy, offset, pageSize);
        attachSpecs(products);
        return products;
    }

    @Override
    public int countAdmin(Integer categoryId, String keyword) {
        return productDao.countAdmin(categoryId, keyword);
    }

    @Override
    public Product findById(Integer id) {
        Product product = productDao.findById(id);
        if (product != null) {
            product.setSpecs(productDao.findSpecs(id));
        }
        return product;
    }

    @Override
    public List<Product> findHotSales(int limit) {
        List<Product> products = productDao.findHotSales(limit);
        attachSpecs(products);
        return products;
    }

    @Override
    public List<Product> findNewProducts(int limit) {
        List<Product> products = productDao.findNewProducts(limit);
        attachSpecs(products);
        return products;
    }

    @Override
    public boolean updateSales(Integer id, int quantity) {
        return productDao.updateSales(id, quantity) > 0;
    }

    @Override
    public boolean updateStock(Integer id, int quantity) {
        return productDao.updateStock(id, quantity) > 0;
    }

    @Override
    public boolean add(Product product) {
        return productDao.insert(product) > 0;
    }

    @Override
    public boolean delete(Integer id) {
        return productDao.delete(id) > 0;
    }

    @Override
    public boolean update(Product product) {
        return productDao.update(product) > 0;
    }

    @Override
    public boolean updateStatus(Integer id, Integer status) {
        return productDao.updateStatus(id, status) > 0;
    }

    @Override
    public List<ProductSpec> findSpecs(Integer productId) {
        return productDao.findSpecs(productId);
    }

    @Override
    public ProductSpec findSpecById(Integer id) {
        return productDao.findSpecById(id);
    }

    private void attachSpecs(List<Product> products) {
        if (products.isEmpty()) {
            return;
        }
        List<Integer> ids = new ArrayList<>(products.size());
        for (Product product : products) {
            ids.add(product.getId());
        }
        Map<Integer, List<ProductSpec>> grouped = productDao.findSpecsByProductIds(ids);
        for (Product product : products) {
            List<ProductSpec> specs = grouped.get(product.getId());
            product.setSpecs(specs != null ? specs : Collections.emptyList());
        }
    }
}
