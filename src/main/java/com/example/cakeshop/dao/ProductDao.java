package com.example.cakeshop.dao;

import com.example.cakeshop.model.Product;
import com.example.cakeshop.model.ProductSpec;

import java.util.List;
import java.util.Map;

/**
 * 商品数据访问接口
 */
public interface ProductDao {

    List<Product> findAll(Integer categoryId, String keyword, String orderBy, int offset, int pageSize);

    int count(Integer categoryId, String keyword);

    List<Product> findAllAdmin(Integer categoryId, String keyword, String orderBy, int offset, int pageSize);

    int countAdmin(Integer categoryId, String keyword);

    Product findById(Integer id);

    List<Product> findHotSales(int limit);

    List<Product> findNewProducts(int limit);

    int updateSales(Integer id, int quantity);

    int insert(Product product);

    int delete(Integer id);

    int update(Product product);

    int updateStatus(Integer id, Integer status);

    int updateStock(Integer id, int quantity);

    List<ProductSpec> findSpecs(Integer productId);

    /**
     * 批量查询多个商品的规格，按商品 ID 分组返回，消除逐商品查询的 N+1。
     */
    Map<Integer, List<ProductSpec>> findSpecsByProductIds(List<Integer> productIds);

    int updateSpecStock(Integer specId, int quantity);

    int restoreSpecStock(Integer specId, int quantity);

    int restoreStock(Integer id, int quantity);

    int restoreSales(Integer id, int quantity);

    ProductSpec findSpecById(Integer id);
}
