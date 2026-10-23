package com.example.cakeshop.util;

import java.util.HashMap;
import java.util.Map;

/**
 * 统一响应结果工具类
 */
public class ResultUtil {

    /**
     * 成功响应（无数据）
     */
    public static Map<String, Object> success() {
        return success("操作成功", null);
    }

    /**
     * 成功响应（带数据）
     */
    public static Map<String, Object> success(Object data) {
        return success("操作成功", data);
    }

    /**
     * 成功响应（带消息和数据）
     */
    public static Map<String, Object> success(String msg, Object data) {
        Map<String, Object> result = new HashMap<>();
        result.put("code", 200);
        result.put("msg", msg);
        result.put("data", data);
        return result;
    }

    /**
     * 失败响应
     */
    public static Map<String, Object> error(String msg) {
        return error(400, msg);
    }

    /**
     * 失败响应（带状态码）
     */
    public static Map<String, Object> error(int code, String msg) {
        Map<String, Object> result = new HashMap<>();
        result.put("code", code);
        result.put("msg", msg);
        result.put("data", null);
        return result;
    }

    /**
     * 未登录响应
     */
    public static Map<String, Object> unauthorized() {
        return error(401, "请先登录");
    }

    /**
     * 无权限响应
     */
    public static Map<String, Object> forbidden() {
        return error(403, "无权限访问");
    }
}
