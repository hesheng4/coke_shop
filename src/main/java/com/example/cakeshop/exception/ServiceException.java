package com.example.cakeshop.exception;

/**
 * 业务规则不满足，code 沿用响应体里的业务状态码约定。
 */
public class ServiceException extends RuntimeException {

    private final int code;

    public ServiceException(String message) {
        this(400, message);
    }

    public ServiceException(int code, String message) {
        super(message);
        this.code = code;
    }

    public ServiceException(String message, Throwable cause) {
        super(message, cause);
        this.code = 400;
    }

    public int getCode() {
        return code;
    }

    public static ServiceException notFound(String message) {
        return new ServiceException(404, message);
    }

    public static ServiceException forbidden(String message) {
        return new ServiceException(403, message);
    }
}
