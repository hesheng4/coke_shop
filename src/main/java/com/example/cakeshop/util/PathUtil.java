package com.example.cakeshop.util;

import javax.servlet.http.HttpServletRequest;

/**
 * 路径工具类
 */
public class PathUtil {

    /**
     * 清理路径：去除 .jsp 后缀和前导斜杠
     */
    public static String cleanPath(String path) {
        if (path == null) {
            return "";
        }
        // 去除 .jsp 后缀
        if (path.endsWith(".jsp")) {
            path = path.substring(0, path.length() - 4);
        }
        // 去除前导斜杠
        if (path.startsWith("/")) {
            path = path.substring(1);
        }
        return path;
    }

    /**
     * 匹配路径
     */
    public static boolean matchPath(String path, String target) {
        return target.equals(cleanPath(path));
    }

    /**
     * 取去掉 contextPath 之后的请求路径，供过滤器做策略匹配
     */
    public static String requestPath(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        if (contextPath != null && !contextPath.isEmpty() && uri.startsWith(contextPath)) {
            uri = uri.substring(contextPath.length());
        }
        return uri.isEmpty() ? "/" : uri;
    }
}
