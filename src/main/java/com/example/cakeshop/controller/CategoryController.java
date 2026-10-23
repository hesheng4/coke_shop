package com.example.cakeshop.controller;

import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.model.Category;
import com.example.cakeshop.service.CategoryService;
import com.example.cakeshop.service.impl.CategoryServiceImpl;
import com.example.cakeshop.util.ApiRouter;
import com.example.cakeshop.util.JsonUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 分类控制器：路由表分发。
 * 管理员鉴权已由 AccessControlFilter 集中处理（/api/category 非 GET 需管理员），此处不再校验。
 *
 * 接口列表：
 *   GET    /api/category[|/|/tree]        分类树
 *   GET    /api/category/treeWithCount    分类树（带商品数）
 *   GET    /api/category/list             扁平列表
 *   GET    /api/category/top              顶级分类
 *   GET    /api/category/{id}             单个分类详情
 *   POST   /api/category[|/add]           新增分类
 *   PUT    /api/category/{id}             更新分类
 *   PUT    /api/category/{id}/status      更新分类状态
 *   DELETE /api/category/{id}             删除分类
 */
@WebServlet("/api/category/*")
public class CategoryController extends AbstractApiServlet {

    private static final long serialVersionUID = 1L;

    private static final int STATUS_DISABLED = 0;
    private static final int STATUS_ENABLED = 1;

    private final CategoryService categoryService = new CategoryServiceImpl();

    @Override
    protected ApiRouter buildRouter() {
        return new ApiRouter()
                .on("GET", "", this::tree)
                .on("GET", "tree", this::tree)
                .on("GET", "treeWithCount", this::treeWithCount)
                .on("GET", "list", this::list)
                .on("GET", "top", this::top)
                .on("GET", "{id}", this::detail)
                .on("POST", "", this::add)
                .on("POST", "add", this::add)
                .on("PUT", "{id}", this::update)
                .on("PUT", "{id}/status", this::updateStatus)
                .on("DELETE", "{id}", this::delete);
    }

    private void tree(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Category> categories = categoryService.findTree();
        JsonUtil.writeSuccess(response, categories);
    }

    private void treeWithCount(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Category> categories = categoryService.findTreeWithProductCount();
        JsonUtil.writeSuccess(response, categories);
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Category> categories = categoryService.findAll();
        JsonUtil.writeSuccess(response, categories);
    }

    private void top(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Category> categories = categoryService.findTopLevel();
        JsonUtil.writeSuccess(response, categories);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseNumericOrThrow(ApiRouter.pathVariable(request, "id"));
        Category category = categoryService.findById(id);
        if (category == null) {
            throw ServiceException.notFound("分类不存在");
        }
        JsonUtil.writeSuccess(response, category);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Category category = parseFromRequest(request);
        if (categoryService.add(category)) {
            JsonUtil.writeSuccess(response, "添加成功");
        } else {
            JsonUtil.writeError(response, "添加失败");
        }
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseNumericOrThrow(ApiRouter.pathVariable(request, "id"));
        Category category = parseFromRequest(request);
        category.setId(id);
        if (categoryService.update(category)) {
            JsonUtil.writeSuccess(response, "更新成功");
        } else {
            JsonUtil.writeError(response, "更新失败");
        }
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseNumericOrThrow(ApiRouter.pathVariable(request, "id"));
        String statusStr = request.getParameter("status");
        if (statusStr == null || statusStr.isEmpty()) {
            throw new ServiceException("状态不能为空");
        }
        int status;
        try {
            status = Integer.parseInt(statusStr);
        } catch (NumberFormatException e) {
            throw new ServiceException("状态格式错误");
        }
        if (status != STATUS_DISABLED && status != STATUS_ENABLED) {
            throw new ServiceException("状态值只能为 0(禁用) 或 1(正常)");
        }
        if (categoryService.updateStatus(id, status)) {
            JsonUtil.writeSuccess(response, status == STATUS_ENABLED ? "已取消禁用" : "已禁用");
        } else {
            JsonUtil.writeError(response, "状态更新失败，分类可能不存在");
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseNumericOrThrow(ApiRouter.pathVariable(request, "id"));
        if (categoryService.delete(id)) {
            JsonUtil.writeSuccess(response, "删除成功");
        } else {
            JsonUtil.writeError(response, "删除失败");
        }
    }

    /**
     * 从请求参数构造 Category 对象。
     * 支持 URL 查询参数（适配 PUT 请求体不被容器解析的情况）
     */
    private Category parseFromRequest(HttpServletRequest request) {
        Category category = new Category();
        category.setName(request.getParameter("name"));

        String parentIdStr = request.getParameter("parentId");
        if (parentIdStr != null && !parentIdStr.isEmpty()) {
            try {
                category.setParentId(Integer.parseInt(parentIdStr));
            } catch (NumberFormatException ignored) {
                // 可选参数，非法时保持为空由业务层取默认值
            }
        }

        String sortOrderStr = request.getParameter("sortOrder");
        if (sortOrderStr != null && !sortOrderStr.isEmpty()) {
            try {
                category.setSortOrder(Integer.parseInt(sortOrderStr));
            } catch (NumberFormatException ignored) {
                // 可选参数，非法时保持为空由业务层取默认值
            }
        }

        String statusStr = request.getParameter("status");
        if (statusStr != null && !statusStr.isEmpty()) {
            try {
                category.setStatus(Integer.parseInt(statusStr));
            } catch (NumberFormatException ignored) {
                // 可选参数，非法时保持为空由业务层取默认值
            }
        }
        return category;
    }

    // 老代码只对纯数字路径路由，非数字视为接口不存在
    private int parseNumericOrThrow(String value) {
        if (value == null || !value.matches("\\d+")) {
            throw new ServiceException("接口不存在");
        }
        return Integer.parseInt(value);
    }
}
