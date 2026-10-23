package com.example.cakeshop.service;

import com.example.cakeshop.model.Product;
import com.example.cakeshop.model.ProductSpec;

import java.util.List;

/**
 * 商品业务逻辑接口
 */
public interface ProductService {

    List<Product> findAll(Integer categoryId, String keyword, String orderBy, int page, int pageSize);

    int count(Integer categoryId, String keyword);

    List<Product> findAllAdmin(Integer categoryId, String keyword, String orderBy, int page, int pageSize);

    int countAdmin(Integer categoryId, String keyword);

    Product findById(Integer id);

    List<Product> findHotSales(int limit);

    List<Product> findNewProducts(int limit);

    boolean updateSales(Integer id, int quantity);

    boolean updateStock(Integer id, int quantity);

    boolean add(Product product);

    boolean delete(Integer id);

    boolean update(Product product);

    boolean updateStatus(Integer id, Integer status);

    List<ProductSpec> findSpecs(Integer productId);

    ProductSpec findSpecById(Integer id);
}
