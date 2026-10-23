package com.example.cakeshop.listener;

import com.example.cakeshop.constant.SessionKeys;
import com.example.cakeshop.ds.DataSourceFactory;
import com.example.cakeshop.util.TokenUtil;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 应用启动时校验数据源连通性；会话创建时签发 CSRF 令牌。
 */
@WebListener
public class AppListener implements ServletContextListener, HttpSessionListener {

    private static final Logger log = Logger.getLogger(AppListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try (Connection connection = DataSourceFactory.getDataSource().getConnection()) {
            log.info("数据源就绪: " + connection.getMetaData().getURL());
        } catch (SQLException e) {
            sce.getServletContext().log("数据库连通性检查失败: " + e.getMessage());
            log.log(Level.WARNING, "数据库连通性检查失败", e);
        }
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        se.getSession().setAttribute(SessionKeys.CSRF_TOKEN, TokenUtil.random(32));
    }
}
