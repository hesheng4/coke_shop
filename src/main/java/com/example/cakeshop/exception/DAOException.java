package com.example.cakeshop.exception;

/**
 * 数据访问失败，替代逐层抛出的 SQLException。
 */
public class DAOException extends RuntimeException {

    public DAOException(String message, Throwable cause) {
        super(message, cause);
    }

    public DAOException(String message) {
        super(message);
    }
}
