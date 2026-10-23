package com.example.cakeshop.util;

import java.util.HashMap;
import java.util.Map;

/**
 * 分页工具类
 */
public class PageUtil {

    private int page;        // 当前页码
    private int pageSize;    // 每页大小
    private int totalCount;  // 总记录数
    private int totalPages;  // 总页数

    public PageUtil() {
        this.page = 1;
        this.pageSize = 10;
    }

    public PageUtil(int page, int pageSize) {
        this.page = page > 0 ? page : 1;
        this.pageSize = pageSize > 0 ? pageSize : 10;
    }

    /**
     * 获取起始行号
     */
    public int getOffset() {
        return (page - 1) * pageSize;
    }

    /**
     * 计算总页数
     */
    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
        this.totalPages = (totalCount + pageSize - 1) / pageSize;
    }

    /**
     * 获取分页信息
     */
    public Map<String, Object> getPageInfo() {
        Map<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("page", page);
        pageInfo.put("pageSize", pageSize);
        pageInfo.put("totalCount", totalCount);
        pageInfo.put("totalPages", totalPages);
        pageInfo.put("hasPrev", page > 1);
        pageInfo.put("hasNext", page < totalPages);
        return pageInfo;
    }

    // Getters and Setters
    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page > 0 ? page : 1;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize > 0 ? pageSize : 10;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public int getTotalPages() {
        return totalPages;
    }
}
