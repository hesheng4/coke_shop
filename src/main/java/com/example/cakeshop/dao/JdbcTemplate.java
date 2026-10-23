package com.example.cakeshop.dao;

import com.example.cakeshop.exception.DAOException;
import com.example.cakeshop.tx.TransactionManager;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * JDBC 模板：统一参数绑定、结果集遍历与连接归还，事务中的 DAO 自动复用当前连接。
 */
public final class JdbcTemplate {

    private JdbcTemplate() {
    }

    public static <T> List<T> query(String sql, RowMapper<T> mapper, Object... params) {
        Connection connection = acquire();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            bind(statement, params);
            try (ResultSet resultSet = statement.executeQuery()) {
                List<T> rows = new ArrayList<>();
                while (resultSet.next()) {
                    rows.add(mapper.map(resultSet));
                }
                return rows;
            }
        } catch (SQLException e) {
            throw new DAOException(describe(sql, e), e);
        } finally {
            release(connection);
        }
    }

    public static <T> T queryFirst(String sql, RowMapper<T> mapper, Object... params) {
        List<T> rows = query(sql, mapper, params);
        return rows.isEmpty() ? null : rows.get(0);
    }

    public static <T> T queryScalar(String sql, Class<T> type, Object... params) {
        Connection connection = acquire();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            bind(statement, params);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? convert(resultSet.getObject(1), type) : null;
            }
        } catch (SQLException e) {
            throw new DAOException(describe(sql, e), e);
        } finally {
            release(connection);
        }
    }

    public static int update(String sql, Object... params) {
        Connection connection = acquire();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            bind(statement, params);
            return statement.executeUpdate();
        } catch (SQLException e) {
            throw new DAOException(describe(sql, e), e);
        } finally {
            release(connection);
        }
    }

    public static int insert(String sql, Object... params) {
        Connection connection = acquire();
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bind(statement, params);
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new DAOException("插入后未取得自增主键: " + sql);
                }
                return keys.getInt(1);
            }
        } catch (SQLException e) {
            throw new DAOException(describe(sql, e), e);
        } finally {
            release(connection);
        }
    }

    private static Connection acquire() {
        try {
            return TransactionManager.currentConnection();
        } catch (SQLException e) {
            throw new DAOException("获取数据库连接失败", e);
        }
    }

    private static void release(Connection connection) {
        if (TransactionManager.isActive()) {
            return;
        }
        try {
            connection.close();
        } catch (SQLException ignored) {
        }
    }

    private static void bind(PreparedStatement statement, Object[] params) throws SQLException {
        if (params == null) {
            return;
        }
        for (int i = 0; i < params.length; i++) {
            Object param = params[i];
            if (param == null) {
                statement.setNull(i + 1, Types.NULL);
            } else if (param instanceof Date) {
                statement.setTimestamp(i + 1, new Timestamp(((Date) param).getTime()));
            } else {
                statement.setObject(i + 1, param);
            }
        }
    }

    private static <T> T convert(Object value, Class<T> type) {
        if (value == null) {
            return null;
        }
        if (type.isInstance(value)) {
            return type.cast(value);
        }
        if (value instanceof Number) {
            Number number = (Number) value;
            if (type == Integer.class) {
                return type.cast(number.intValue());
            }
            if (type == Long.class) {
                return type.cast(number.longValue());
            }
            if (type == BigDecimal.class) {
                return type.cast(new BigDecimal(number.toString()));
            }
        }
        if (type == String.class) {
            return type.cast(value.toString());
        }
        throw new DAOException("不支持的标量转换: " + value.getClass().getName() + " -> " + type.getName());
    }

    private static String describe(String sql, SQLException e) {
        return e.getMessage() + " | SQL: " + sql.replaceAll("\\s+", " ").trim();
    }
}
