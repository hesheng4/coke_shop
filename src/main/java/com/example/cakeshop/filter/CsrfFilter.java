package com.example.cakeshop.filter;

import com.example.cakeshop.constant.SessionKeys;
import com.example.cakeshop.util.JsonUtil;
import com.example.cakeshop.util.PathUtil;
import com.example.cakeshop.util.TokenUtil;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * CSRF 防护：已建立会话的写接口必须回传会话令牌，登录前的匿名接口除外。
 */
public class CsrfFilter implements Filter {

    private static final String TOKEN_HEADER = "X-CSRF-Token";
    private static final String TOKEN_PARAMETER = "csrfToken";
    private static final Set<String> SAFE_METHODS = new HashSet<>(Arrays.asList("GET", "HEAD", "OPTIONS"));
    private static final Set<String> ANONYMOUS_APIS = new HashSet<>(Arrays.asList(
            "/api/user/register", "/api/user/login", "/api/user/logout", "/api/security/csrf"));

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String method = httpRequest.getMethod().toUpperCase();
        String path = PathUtil.requestPath(httpRequest);
        if (SAFE_METHODS.contains(method) || !path.startsWith("/api/") || ANONYMOUS_APIS.contains(path)) {
            chain.doFilter(request, response);
            return;
        }
        HttpSession session = httpRequest.getSession(false);
        Object issued = session == null ? null : session.getAttribute(SessionKeys.CSRF_TOKEN);
        if (issued == null) {
            chain.doFilter(request, response);
            return;
        }
        String submitted = httpRequest.getHeader(TOKEN_HEADER);
        if (submitted == null || submitted.isEmpty()) {
            submitted = httpRequest.getParameter(TOKEN_PARAMETER);
        }
        if (!TokenUtil.equalsConstantTime(issued.toString(), submitted)) {
            JsonUtil.writeError((HttpServletResponse) response, 403, "请求校验失败，请刷新页面后重试");
            return;
        }
        chain.doFilter(request, response);
    }
}
