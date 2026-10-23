package com.example.cakeshop.ds;

import javax.sql.DataSource;
import java.io.PrintWriter;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.SQLFeatureNotSupportedException;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.logging.Logger;

/**
 * javax.sql.DataSource 的轻量实现，容器 JNDI 数据源不可用时的本地连接池。
 */
public class PooledDataSource implements DataSource {

    private static final Method CLOSE_METHOD;

    static {
        try {
            CLOSE_METHOD = Connection.class.getMethod("close");
        } catch (NoSuchMethodException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private final String url;
    private final String username;
    private final String password;
    private final int maxActive;
    private final long maxWaitMillis;
    private final Semaphore slots;
    private final Deque<Connection> idle = new ArrayDeque<>();
    private PrintWriter logWriter;
    private int loginTimeoutSeconds;

    public PooledDataSource(String driverClass, String url, String username, String password,
                            int maxActive, long maxWaitMillis) {
        this.url = url;
        this.username = username;
        this.password = password;
        this.maxActive = maxActive;
        this.maxWaitMillis = maxWaitMillis;
        this.slots = new Semaphore(maxActive, true);
        try {
            Class.forName(driverClass);
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBC 驱动未找到: " + driverClass, e);
        }
    }

    @Override
    public Connection getConnection() throws SQLException {
        if (!tryAcquireSlot()) {
            throw new SQLException("获取数据库连接超时：连接池已达上限 " + maxActive);
        }
        Connection physical = takeIdle();
        if (physical == null) {
            try {
                physical = DriverManager.getConnection(url, username, password);
            } catch (SQLException e) {
                slots.release();
                throw e;
            }
        }
        return wrap(physical);
    }

    @Override
    public Connection getConnection(String username, String password) throws SQLException {
        throw new SQLFeatureNotSupportedException("连接池使用配置的凭据，不支持按调用方凭据获取连接");
    }

    private boolean tryAcquireSlot() throws SQLException {
        try {
            return slots.tryAcquire(maxWaitMillis, TimeUnit.MILLISECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new SQLException("等待数据库连接时被中断", e);
        }
    }

    private Connection takeIdle() {
        synchronized (idle) {
            Connection candidate;
            while ((candidate = idle.pollFirst()) != null) {
                if (isUsable(candidate)) {
                    return candidate;
                }
                closeQuietly(candidate);
            }
            return null;
        }
    }

    private boolean isUsable(Connection candidate) {
        try {
            return !candidate.isClosed() && candidate.isValid(2);
        } catch (SQLException e) {
            return false;
        }
    }

    private void returnConnection(Connection physical) {
        boolean discard = false;
        try {
            if (!physical.getAutoCommit()) {
                physical.setAutoCommit(true);
            }
            if (physical.isClosed()) {
                discard = true;
            }
        } catch (SQLException e) {
            discard = true;
        }
        if (discard) {
            closeQuietly(physical);
        } else {
            synchronized (idle) {
                idle.offerLast(physical);
            }
        }
        slots.release();
    }

    private Connection wrap(Connection physical) {
        final AtomicBoolean returned = new AtomicBoolean();
        InvocationHandler handler = (proxy, method, args) -> {
            if (CLOSE_METHOD.equals(method)) {
                if (returned.compareAndSet(false, true)) {
                    returnConnection(physical);
                }
                return null;
            }
            String name = method.getName();
            if ("unwrap".equals(name)) {
                return proxy;
            }
            if ("isWrapperFor".equals(name)) {
                return Boolean.TRUE;
            }
            try {
                return method.invoke(physical, args);
            } catch (InvocationTargetException e) {
                throw e.getCause();
            }
        };
        return (Connection) Proxy.newProxyInstance(PooledDataSource.class.getClassLoader(),
                new Class<?>[]{Connection.class}, handler);
    }

    private void closeQuietly(Connection connection) {
        try {
            connection.close();
        } catch (SQLException ignored) {
        }
    }

    @Override
    public PrintWriter getLogWriter() {
        return logWriter;
    }

    @Override
    public void setLogWriter(PrintWriter out) {
        this.logWriter = out;
    }

    @Override
    public void setLoginTimeout(int seconds) {
        this.loginTimeoutSeconds = seconds;
    }

    @Override
    public int getLoginTimeout() {
        return loginTimeoutSeconds;
    }

    @Override
    public Logger getParentLogger() throws SQLFeatureNotSupportedException {
        throw new SQLFeatureNotSupportedException();
    }

    @Override
    public <T> T unwrap(Class<T> iface) throws SQLException {
        if (isWrapperFor(iface)) {
            return iface.cast(this);
        }
        throw new SQLException("不是 " + iface.getName() + " 的包装");
    }

    @Override
    public boolean isWrapperFor(Class<?> iface) {
        return iface != null && iface.isInstance(this);
    }
}
