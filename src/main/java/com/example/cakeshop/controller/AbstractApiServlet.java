package com.example.cakeshop.controller;

import com.example.cakeshop.exception.DAOException;
import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.util.ApiRouter;
import com.example.cakeshop.util.JsonUtil;
import com.example.cakeshop.util.PathUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 接口控制器基类：路由表分发 + 统一响应头与异常出口。
 */
public abstract class AbstractApiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final Logger log = Logger.getLogger(getClass().getName());
    private volatile ApiRouter router;

    protected abstract ApiRouter buildRouter();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String path = PathUtil.cleanPath(request.getPathInfo());
        try {
            if (!router().dispatch(request.getMethod(), path, request, response)) {
                JsonUtil.writeError(response, "接口不存在");
            }
        } catch (ServiceException e) {
            JsonUtil.writeError(response, e.getCode(), e.getMessage());
        } catch (DAOException e) {
            log.log(Level.SEVERE, "数据访问失败: " + request.getRequestURI(), e);
            JsonUtil.writeError(response, 500, "服务器繁忙，请稍后重试");
        } catch (IOException | ServletException e) {
            throw e;
        } catch (Exception e) {
            log.log(Level.SEVERE, "接口处理失败: " + request.getRequestURI(), e);
            JsonUtil.writeError(response, 500, "服务器内部错误");
        }
    }

    private ApiRouter router() {
        ApiRouter current = router;
        if (current == null) {
            synchronized (this) {
                if (router == null) {
                    router = buildRouter();
                }
                current = router;
            }
        }
        return current;
    }
}
