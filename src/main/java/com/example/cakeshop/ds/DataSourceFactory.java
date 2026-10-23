package com.example.cakeshop.ds;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Logger;

/**
 * 数据源入口：优先使用 Servlet 容器托管的 JNDI 数据源，未配置时回落到应用内连接池。
 */
public final class DataSourceFactory {

    public static final String JNDI_NAME = "java:comp/env/jdbc/cakeShopDS";

    private static final String CONFIG_FILE = "db.properties";
    private static final Logger log = Logger.getLogger(DataSourceFactory.class.getName());

    private static volatile DataSource dataSource;

    private DataSourceFactory() {
    }

    public static DataSource getDataSource() {
        DataSource current = dataSource;
        if (current != null) {
            return current;
        }
        synchronized (DataSourceFactory.class) {
            if (dataSource == null) {
                dataSource = resolve();
            }
            return dataSource;
        }
    }

    private static DataSource resolve() {
        DataSource jndi = lookupJndi();
        if (jndi != null) {
            log.info("已绑定容器 JNDI 数据源 " + JNDI_NAME);
            return jndi;
        }
        log.info("未发现 JNDI 数据源，使用应用内连接池 " + CONFIG_FILE);
        return createPooledDataSource();
    }

    private static DataSource lookupJndi() {
        try {
            Context context = new InitialContext();
            Object referenced = context.lookup(JNDI_NAME);
            return referenced instanceof DataSource ? (DataSource) referenced : null;
        } catch (NamingException e) {
            return null;
        }
    }

    private static DataSource createPooledDataSource() {
        Properties properties = loadProperties();
        return new PooledDataSource(
                required(properties, "jdbc.driver"),
                required(properties, "jdbc.url"),
                required(properties, "jdbc.username"),
                properties.getProperty("jdbc.password", ""),
                integer(required(properties, "jdbc.maxActive"), 20),
                integer(properties.getProperty("jdbc.maxWait", "3000"), 3000));
    }

    private static Properties loadProperties() {
        Properties properties = new Properties();
        try (InputStream input = DataSourceFactory.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (input == null) {
                throw new IllegalStateException("类路径下缺少 " + CONFIG_FILE);
            }
            properties.load(input);
        } catch (IOException e) {
            throw new IllegalStateException("读取 " + CONFIG_FILE + " 失败", e);
        }
        return properties;
    }

    private static String required(Properties properties, String key) {
        String value = properties.getProperty(key);
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalStateException(CONFIG_FILE + " 缺少配置项 " + key);
        }
        return value.trim();
    }

    private static int integer(String value, int fallback) {
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
