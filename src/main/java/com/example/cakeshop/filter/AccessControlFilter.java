package com.example.cakeshop.filter;

import com.example.cakeshop.model.User;
import com.example.cakeshop.util.JsonUtil;
import com.example.cakeshop.util.PathUtil;
import com.example.cakeshop.util.SessionUtil;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * 声明式访问控制：把原先散落在各控制器方法里的会话判空与管理员判定集中到一处。
 */
public class AccessControlFilter implements Filter {

    private static final Set<String> READ_METHODS = new HashSet<>(Arrays.asList("GET", "HEAD", "OPTIONS"));

    private static final String[] LOGIN_PREFIXES = {
            "/api/order",
            "/api/cart",
            "/api/user/address"
    };
    private static final String[] LOGIN_PREFIX_EXCEPTIONS = {
            "/api/cart/count"
    };
    private static final String[] LOGIN_EXACT_PATHS = {
            "/api/user/info",
            "/api/user/password"
    };
    private static final String[] ADMIN_PREFIXES = {
            "/api/admin"
    };
    private static final String[] ADMIN_WRITE_PREFIXES = {
            "/api/category"
    };
    private static final String ADMIN_PAGE_PREFIX = "/admin";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = PathUtil.requestPath(httpRequest);
        String method = httpRequest.getMethod().toUpperCase();
        User user = SessionUtil.currentUser(httpRequest);

        if (path.startsWith(ADMIN_PAGE_PREFIX)) {
            if (SessionUtil.isAdmin(user)) {
                chain.doFilter(request, response);
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/user/login.jsp");
            }
            return;
        }

        if (requiresAdmin(path, method)) {
            if (user == null) {
                JsonUtil.writeError(httpResponse, 401, "请先登录");
                return;
            }
            if (!SessionUtil.isAdmin(user)) {
                JsonUtil.writeError(httpResponse, 403, "无权限访问");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        if (requiresLogin(path) && user == null) {
            JsonUtil.writeError(httpResponse, 401, "请先登录");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean requiresAdmin(String path, String method) {
        if (startsWithAny(path, ADMIN_PREFIXES)) {
            return true;
        }
        return !READ_METHODS.contains(method) && startsWithAny(path, ADMIN_WRITE_PREFIXES);
    }

    private boolean requiresLogin(String path) {
        for (String exact : LOGIN_EXACT_PATHS) {
            if (path.equals(exact)) {
                return true;
            }
        }
        for (String exception : LOGIN_PREFIX_EXCEPTIONS) {
            if (path.equals(exception)) {
                return false;
            }
        }
        return startsWithAny(path, LOGIN_PREFIXES);
    }

    private boolean startsWithAny(String path, String[] prefixes) {
        for (String prefix : prefixes) {
            if (path.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }
}
