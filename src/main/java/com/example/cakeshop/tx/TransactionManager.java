package com.example.cakeshop.tx;

import com.example.cakeshop.ds.DataSourceFactory;
import com.example.cakeshop.exception.DAOException;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 基于 ThreadLocal 的 JDBC 事务边界：回调内的 DAO 调用共享同一连接，异常一律回滚。
 */
public final class TransactionManager {

    private static final Logger log = Logger.getLogger(TransactionManager.class.getName());
    private static final ThreadLocal<Connection> CURRENT = new ThreadLocal<>();

    private TransactionManager() {
    }

    public static <T> T execute(TransactionCallback<T> callback) {
        Connection outer = CURRENT.get();
        if (outer != null) {
            return joinOuterTransaction(callback, outer);
        }
        Connection connection = null;
        try {
            connection = DataSourceFactory.getDataSource().getConnection();
            connection.setAutoCommit(false);
            CURRENT.set(connection);
            T result = callback.doInTransaction(connection);
            connection.commit();
            return result;
        } catch (SQLException e) {
            rollback(connection);
            throw new DAOException("事务执行失败，已回滚", e);
        } catch (RuntimeException | Error e) {
            rollback(connection);
            throw e;
        } finally {
            CURRENT.remove();
            release(connection);
        }
    }

    private static <T> T joinOuterTransaction(TransactionCallback<T> callback, Connection connection) {
        try {
            return callback.doInTransaction(connection);
        } catch (SQLException e) {
            throw new DAOException("事务内操作失败", e);
        }
    }

    public static Connection currentConnection() throws SQLException {
        Connection connection = CURRENT.get();
        return connection != null ? connection : DataSourceFactory.getDataSource().getConnection();
    }

    public static boolean isActive() {
        return CURRENT.get() != null;
    }

    private static void rollback(Connection connection) {
        if (connection == null) {
            return;
        }
        try {
            connection.rollback();
        } catch (SQLException e) {
            log.log(Level.SEVERE, "事务回滚失败", e);
        }
    }

    private static void release(Connection connection) {
        if (connection == null) {
            return;
        }
        try {
            connection.setAutoCommit(true);
        } catch (SQLException ignored) {
        }
        try {
            connection.close();
        } catch (SQLException ignored) {
        }
    }
}
