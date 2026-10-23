package com.example.cakeshop.controller;

import com.example.cakeshop.model.Product;
import com.example.cakeshop.model.ProductSpec;
import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.service.ProductService;
import com.example.cakeshop.service.impl.ProductServiceImpl;
import com.example.cakeshop.util.ApiRouter;
import com.example.cakeshop.util.JsonUtil;
import com.example.cakeshop.util.PageUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 商品控制器：路由表分发，异常统一交由基类处理。
 */
@WebServlet("/api/product/*")
public class ProductController extends AbstractApiServlet {

    private static final long serialVersionUID = 1L;

    private static final int DEFAULT_PAGE = 1;
    private static final int DEFAULT_PAGE_SIZE = 10;
    private static final int DEFAULT_LIMIT = 8;

    private final ProductService productService = new ProductServiceImpl();

    @Override
    protected ApiRouter buildRouter() {
        return new ApiRouter()
                .on("GET", "", this::list)
                .on("GET", "list", this::list)
                .on("GET", "detail", this::detail)
                .on("GET", "hot", this::hot)
                .on("GET", "new", this::newProducts)
                .on("GET", "specs", this::specs);
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer categoryId = parseOptionalInt(request.getParameter("categoryId"));
        String keyword = request.getParameter("keyword");
        String orderBy = request.getParameter("orderBy");
        int page = parseIntOrDefault(request.getParameter("page"), DEFAULT_PAGE);
        int pageSize = parseIntOrDefault(request.getParameter("pageSize"), DEFAULT_PAGE_SIZE);

        PageUtil pageUtil = new PageUtil(page, pageSize);
        List<Product> products = productService.findAll(categoryId, keyword, orderBy, page, pageSize);
        pageUtil.setTotalCount(productService.count(categoryId, keyword));

        Map<String, Object> result = new HashMap<>();
        result.put("list", products);
        result.put("page", pageUtil.getPageInfo());
        JsonUtil.writeSuccess(response, result);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            throw new ServiceException("商品ID不能为空");
        }
        Product product = productService.findById(parseIdOrThrow(idStr));
        if (product == null) {
            throw new ServiceException("商品不存在");
        }
        JsonUtil.writeSuccess(response, product);
    }

    private void hot(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int limit = parseIntOrDefault(request.getParameter("limit"), DEFAULT_LIMIT);
        List<Product> products = productService.findHotSales(limit);
        JsonUtil.writeSuccess(response, products);
    }

    private void newProducts(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int limit = parseIntOrDefault(request.getParameter("limit"), DEFAULT_LIMIT);
        List<Product> products = productService.findNewProducts(limit);
        JsonUtil.writeSuccess(response, products);
    }

    private void specs(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String productIdStr = request.getParameter("productId");
        if (productIdStr == null || productIdStr.isEmpty()) {
            throw new ServiceException("商品ID不能为空");
        }
        List<ProductSpec> specs = productService.findSpecs(parseIdOrThrow(productIdStr));
        JsonUtil.writeSuccess(response, specs);
    }

    private Integer parseOptionalInt(String value) {
        if (value == null || value.isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        if (value == null || value.isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private int parseIdOrThrow(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new ServiceException("商品ID格式错误");
        }
    }
}
