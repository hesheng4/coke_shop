package com.example.cakeshop.controller;

import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.model.Category;
import com.example.cakeshop.model.Order;
import com.example.cakeshop.model.Product;
import com.example.cakeshop.model.User;
import com.example.cakeshop.service.CategoryService;
import com.example.cakeshop.service.OrderService;
import com.example.cakeshop.service.ProductService;
import com.example.cakeshop.service.UserService;
import com.example.cakeshop.service.impl.CategoryServiceImpl;
import com.example.cakeshop.service.impl.OrderServiceImpl;
import com.example.cakeshop.service.impl.ProductServiceImpl;
import com.example.cakeshop.service.impl.UserServiceImpl;
import com.example.cakeshop.util.ApiRouter;
import com.example.cakeshop.util.JsonUtil;
import com.example.cakeshop.util.PageUtil;
import com.example.cakeshop.util.SessionRegistry;
import com.example.cakeshop.util.SessionUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 后台管理控制器：用户、商品、分类、订单的管理端查询与状态维护。
 * 管理员权限校验由 AccessControlFilter 负责，这里只处理业务。
 */
@WebServlet("/api/admin/*")
public class AdminController extends AbstractApiServlet {

    private static final long serialVersionUID = 1L;

    private static final int DEFAULT_PAGE = 1;
    private static final int DEFAULT_PAGE_SIZE = 10;

    private final UserService userService = new UserServiceImpl();
    private final ProductService productService = new ProductServiceImpl();
    private final OrderService orderService = new OrderServiceImpl();
    private final CategoryService categoryService = new CategoryServiceImpl();

    @Override
    protected ApiRouter buildRouter() {
        return new ApiRouter()
                .on("GET", "", this::index)
                .on("GET", "index", this::index)
                .on("GET", "statistics", this::statistics)
                .on("GET", "user/list", this::userList)
                .on("POST", "user/status", this::updateUserStatus)
                .on("GET", "product/list", this::productList)
                .on("GET", "product/detail", this::productDetail)
                .on("POST", "product/add", this::addProduct)
                .on("POST", "product/update", this::updateProduct)
                .on("POST", "product/delete", this::deleteProduct)
                .on("POST", "product/status", this::updateProductStatus)
                .on("GET", "order/list", this::orderList)
                .on("GET", "order/detail", this::orderDetail)
                .on("POST", "order/ship", this::shipOrder)
                .on("POST", "order/cancel", this::cancelOrder)
                .on("GET", "category/list", this::categoryList)
                .on("GET", "category/tree", this::categoryTree)
                .on("POST", "category/add", this::addCategory)
                .on("POST", "category/update", this::updateCategory)
                .on("POST", "category/delete", this::deleteCategory)
                .on("POST", "category/status", this::updateCategoryStatus);
    }

    private void index(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JsonUtil.writeSuccess(response, overview());
    }

    private void statistics(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JsonUtil.writeSuccess(response, overview());
    }

    private void userList(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int[] params = parsePageParams(request);
        int page = params[0], pageSize = params[1];
        PageUtil pageUtil = new PageUtil(page, pageSize);

        List<User> users = userService.findAll(page, pageSize);
        pageUtil.setTotalCount(userService.count());

        JsonUtil.writeSuccess(response, pageResult(users, pageUtil));
    }

    private void updateUserStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userIdStr = request.getParameter("userId");
        String statusStr = request.getParameter("status");
        if (userIdStr == null || userIdStr.isEmpty()) {
            throw new ServiceException("用户ID不能为空");
        }
        int userId, status;
        try {
            userId = Integer.parseInt(userIdStr);
            status = Integer.parseInt(statusStr);
        } catch (NumberFormatException e) {
            throw new ServiceException("参数格式错误");
        }
        if (status != 0 && status != 1) {
            throw new ServiceException("状态值只能为 0(禁用) 或 1(正常)");
        }
        User current = SessionUtil.currentUser(request);
        if (current != null && current.getId() != null && current.getId().equals(userId)) {
            throw new ServiceException("不能禁用当前登录账号");
        }
        if (!userService.updateStatus(userId, status)) {
            throw new ServiceException("操作失败，用户可能不存在");
        }
        if (status == 0) {
            SessionRegistry.logout(userId);
        }
        JsonUtil.writeSuccess(response, status == 1 ? "已取消禁用" : "已禁用");
    }

    private void productList(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer categoryId = parseOptionalInt(request.getParameter("categoryId"));
        String keyword = request.getParameter("keyword");
        int[] params = parsePageParams(request);
        int page = params[0], pageSize = params[1];
        PageUtil pageUtil = new PageUtil(page, pageSize);

        List<Product> products = productService.findAllAdmin(categoryId, keyword, "id_desc", page, pageSize);
        pageUtil.setTotalCount(productService.countAdmin(categoryId, keyword));

        JsonUtil.writeSuccess(response, pageResult(products, pageUtil));
    }

    private void productDetail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            throw new ServiceException("商品ID不能为空");
        }
        Product product = productService.findById(parseIdOrThrow(idStr, "商品ID格式错误"));
        if (product == null) {
            throw new ServiceException("商品不存在");
        }
        JsonUtil.writeSuccess(response, product);
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        String categoryIdStr = request.getParameter("categoryId");
        String priceStr = request.getParameter("price");
        String originalPriceStr = request.getParameter("originalPrice");
        String stockStr = request.getParameter("stock");
        String description = request.getParameter("description");
        String detail = request.getParameter("detail");
        String image = request.getParameter("image");

        if (name == null || name.trim().isEmpty()) {
            throw new ServiceException("商品名称不能为空");
        }
        int categoryId;
        BigDecimal price;
        try {
            categoryId = Integer.parseInt(categoryIdStr);
            price = new BigDecimal(priceStr);
        } catch (Exception e) {
            throw new ServiceException("参数格式错误");
        }

        Product product = new Product();
        product.setName(name.trim());
        product.setCategoryId(categoryId);
        product.setPrice(price);
        product.setOriginalPrice(parseDecimalOrNull(originalPriceStr));
        product.setStock(parseIntOrDefault(stockStr, 0));
        product.setDescription(description);
        product.setDetail(detail);
        product.setImage(image);
        product.setStatus(1);

        if (!productService.add(product)) {
            throw new ServiceException("添加失败");
        }
        JsonUtil.writeSuccess(response, "添加成功");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String categoryIdStr = request.getParameter("categoryId");
        String priceStr = request.getParameter("price");
        String originalPriceStr = request.getParameter("originalPrice");
        String stockStr = request.getParameter("stock");
        String description = request.getParameter("description");
        String detail = request.getParameter("detail");
        String image = request.getParameter("image");

        if (idStr == null || idStr.isEmpty()) {
            throw new ServiceException("商品ID不能为空");
        }

        Product product = new Product();
        product.setId(parseIdOrThrow(idStr, "商品ID格式错误"));
        product.setName(name != null ? name.trim() : null);

        Integer categoryId = parseOptionalInt(categoryIdStr);
        if (categoryId != null) {
            product.setCategoryId(categoryId);
        }
        BigDecimal price = parseDecimalOrNull(priceStr);
        if (price != null) {
            product.setPrice(price);
        }
        BigDecimal originalPrice = parseDecimalOrNull(originalPriceStr);
        if (originalPrice != null) {
            product.setOriginalPrice(originalPrice);
        }
        Integer stock = parseOptionalInt(stockStr);
        if (stock != null) {
            product.setStock(stock);
        }
        product.setDescription(description);
        product.setDetail(detail);
        product.setImage(image);

        if (!productService.update(product)) {
            throw new ServiceException("更新失败");
        }
        JsonUtil.writeSuccess(response, "更新成功");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("productId");
        if (idStr == null || idStr.isEmpty()) {
            throw new ServiceException("商品ID不能为空");
        }
        if (!productService.delete(parseIdOrThrow(idStr, "商品ID格式错误"))) {
            throw new ServiceException("删除失败");
        }
        JsonUtil.writeSuccess(response, "删除成功");
    }

    private void updateProductStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("productId");
        String statusStr = request.getParameter("status");
        if (idStr == null || idStr.isEmpty()) {
            throw new ServiceException("商品ID不能为空");
        }
        int id, status;
        try {
            id = Integer.parseInt(idStr);
            status = Integer.parseInt(statusStr);
        } catch (NumberFormatException e) {
            throw new ServiceException("参数格式错误");
        }
        if (status != 0 && status != 1) {
            throw new ServiceException("状态值只能为 0(下架) 或 1(上架)");
        }
        if (!productService.updateStatus(id, status)) {
            throw new ServiceException("操作失败，商品可能不存在");
        }
        JsonUtil.writeSuccess(response, status == 1 ? "上架成功" : "下架成功");
    }

    private void categoryList(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JsonUtil.writeSuccess(response, categoryService.findAllAdmin());
    }

    private void categoryTree(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JsonUtil.writeSuccess(response, categoryService.findTree());
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            throw new ServiceException("分类名称不能为空");
        }
        Category category = new Category();
        category.setName(name.trim());
        category.setParentId(parseIntOrDefault(request.getParameter("parentId"), 0));
        category.setSortOrder(parseIntOrDefault(request.getParameter("sortOrder"), 0));
        category.setStatus(1);

        if (!categoryService.add(category)) {
            throw new ServiceException("添加失败");
        }
        JsonUtil.writeSuccess(response, "添加成功");
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String parentIdStr = request.getParameter("parentId");
        String sortOrderStr = request.getParameter("sortOrder");

        if (idStr == null || idStr.isEmpty()) {
            throw new ServiceException("分类ID不能为空");
        }
        Category category = new Category();
        category.setId(parseIdOrThrow(idStr, "分类ID格式错误"));
        category.setName(name != null ? name.trim() : null);
        if (parentIdStr != null && !parentIdStr.isEmpty()) {
            category.setParentId(parseIntOrDefault(parentIdStr, 0));
        }
        if (sortOrderStr != null && !sortOrderStr.isEmpty()) {
            category.setSortOrder(parseIntOrDefault(sortOrderStr, 0));
        }

        if (!categoryService.update(category)) {
            throw new ServiceException("更新失败");
        }
        JsonUtil.writeSuccess(response, "更新成功");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            throw new ServiceException("分类ID不能为空");
        }
        if (!categoryService.delete(parseIdOrThrow(idStr, "分类ID格式错误"))) {
            throw new ServiceException("删除失败");
        }
        JsonUtil.writeSuccess(response, "删除成功");
    }

    private void updateCategoryStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String statusStr = request.getParameter("status");
        if (idStr == null || idStr.isEmpty()) {
            throw new ServiceException("分类ID不能为空");
        }
        int id, status;
        try {
            id = Integer.parseInt(idStr);
            status = Integer.parseInt(statusStr);
        } catch (NumberFormatException e) {
            throw new ServiceException("参数格式错误");
        }
        if (status != 0 && status != 1) {
            throw new ServiceException("状态值只能为 0(禁用) 或 1(正常)");
        }
        if (!categoryService.updateStatus(id, status)) {
            throw new ServiceException("操作失败，分类可能不存在");
        }
        JsonUtil.writeSuccess(response, status == 1 ? "已取消禁用" : "已禁用");
    }

    private void orderList(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer status = parseOptionalInt(request.getParameter("status"));
        int[] params = parsePageParams(request);
        int page = params[0], pageSize = params[1];
        PageUtil pageUtil = new PageUtil(page, pageSize);

        List<Order> orders = orderService.findAll(status, page, pageSize);
        pageUtil.setTotalCount(orderService.count(status));

        JsonUtil.writeSuccess(response, pageResult(orders, pageUtil));
    }

    private void orderDetail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            throw new ServiceException("订单ID不能为空");
        }
        Order order = orderService.findById(parseIdOrThrow(idStr, "订单ID格式错误"));
        if (order == null) {
            throw new ServiceException("订单不存在");
        }
        JsonUtil.writeSuccess(response, order);
    }

    private void shipOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            throw new ServiceException("订单ID不能为空");
        }
        if (!orderService.shipOrder(parseIdOrThrow(orderIdStr, "订单ID格式错误"))) {
            throw new ServiceException("发货失败，请确认订单状态");
        }
        JsonUtil.writeSuccess(response, "发货成功");
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            throw new ServiceException("订单ID不能为空");
        }
        int orderId = parseIdOrThrow(orderIdStr, "订单ID格式错误");
        Order order = orderService.findById(orderId);
        if (order == null) {
            throw new ServiceException("订单不存在");
        }
        if (order.getStatus() != 0 && order.getStatus() != 1) {
            throw new ServiceException("只能取消待付款或待发货的订单");
        }
        if (!orderService.cancelOrder(orderId, order.getUserId())) {
            throw new ServiceException("取消失败");
        }
        JsonUtil.writeSuccess(response, "取消成功");
    }

    private Map<String, Object> overview() {
        Map<String, Object> data = new HashMap<>();
        data.put("userCount", userService.count());
        data.put("orderCount", orderService.count(null));
        data.put("todayOrderCount", orderService.countToday());
        data.put("todaySales", orderService.sumTodaySales());
        data.put("productCount", productService.countAdmin(null, null));
        return data;
    }

    private Map<String, Object> pageResult(List<?> list, PageUtil pageUtil) {
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("page", pageUtil.getPageInfo());
        return result;
    }

    private int[] parsePageParams(HttpServletRequest request) {
        String pageStr = request.getParameter("page");
        String pageSizeStr = request.getParameter("pageSize");
        int page = DEFAULT_PAGE;
        int pageSize = DEFAULT_PAGE_SIZE;
        try {
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
            if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
                pageSize = Integer.parseInt(pageSizeStr);
            }
        } catch (NumberFormatException ignored) {
        }
        return new int[]{page, pageSize};
    }

    private Integer parseOptionalInt(String value) {
        if (value == null || value.isEmpty()) {
            return null;
        }
        try {
            return Integer.valueOf(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        Integer parsed = parseOptionalInt(value);
        return parsed == null ? defaultValue : parsed;
    }

    private BigDecimal parseDecimalOrNull(String value) {
        if (value == null || value.isEmpty()) {
            return null;
        }
        try {
            return new BigDecimal(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private int parseIdOrThrow(String value, String errorMessage) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new ServiceException(errorMessage);
        }
    }
}
