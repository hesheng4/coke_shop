package com.example.cakeshop.controller;

import com.example.cakeshop.constant.SessionKeys;
import com.example.cakeshop.util.JsonUtil;
import com.example.cakeshop.util.TokenUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 下发 CSRF 令牌，供前端在写请求的 X-CSRF-Token 头中回传。
 */
@WebServlet(name = "CsrfTokenServlet", urlPatterns = "/api/security/csrf")
public class CsrfTokenServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        Object token = session.getAttribute(SessionKeys.CSRF_TOKEN);
        if (token == null) {
            token = TokenUtil.random(32);
            session.setAttribute(SessionKeys.CSRF_TOKEN, token);
        }
        JsonUtil.writeSuccess(response, token);
    }
}
