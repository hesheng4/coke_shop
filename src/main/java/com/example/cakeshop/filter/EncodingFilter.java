package com.example.cakeshop.filter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import java.io.IOException;

/**
 * 统一请求/响应编码，替代每个控制器方法里的 setCharacterEncoding。
 */
public class EncodingFilter implements Filter {

    private String encoding = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) {
        String configured = filterConfig.getInitParameter("encoding");
        if (configured != null && !configured.trim().isEmpty()) {
            encoding = configured.trim();
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (request.getCharacterEncoding() == null) {
            request.setCharacterEncoding(encoding);
        }
        response.setCharacterEncoding(encoding);
        chain.doFilter(request, response);
    }
}
