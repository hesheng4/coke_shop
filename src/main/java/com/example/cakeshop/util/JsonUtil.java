package com.example.cakeshop.util;

import com.google.gson.ExclusionStrategy;
import com.google.gson.FieldAttributes;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * JSON工具类
 */
public class JsonUtil {

    private static final Gson gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .addSerializationExclusionStrategy(new ExclusionStrategy() {
                @Override
                public boolean shouldSkipField(FieldAttributes field) {
                    return "password".equals(field.getName());
                }

                @Override
                public boolean shouldSkipClass(Class<?> clazz) {
                    return false;
                }
            })
            .create();

    /**
     * 对象转JSON字符串
     */
    public static String toJson(Object obj) {
        return gson.toJson(obj);
    }

    /**
     * JSON字符串转对象
     */
    public static <T> T fromJson(String json, Class<T> clazz) {
        return gson.fromJson(json, clazz);
    }

    /**
     * 输出JSON响应
     */
    public static void writeJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter writer = response.getWriter();
        writer.write(toJson(data));
        writer.flush();
    }

    /**
     * 输出成功响应
     */
    public static void writeSuccess(HttpServletResponse response) throws IOException {
        writeJson(response, ResultUtil.success());
    }

    /**
     * 输出成功响应（带数据）
     */
    public static void writeSuccess(HttpServletResponse response, Object data) throws IOException {
        writeJson(response, ResultUtil.success(data));
    }

    /**
     * 输出成功响应（带消息）
     */
    public static void writeSuccess(HttpServletResponse response, String msg, Object data) throws IOException {
        writeJson(response, ResultUtil.success(msg, data));
    }

    /**
     * 输出失败响应
     */
    public static void writeError(HttpServletResponse response, String msg) throws IOException {
        writeJson(response, ResultUtil.error(msg));
    }

    /**
     * 输出失败响应（带状态码）
     */
    public static void writeError(HttpServletResponse response, int code, String msg) throws IOException {
        writeJson(response, ResultUtil.error(code, msg));
    }
}
