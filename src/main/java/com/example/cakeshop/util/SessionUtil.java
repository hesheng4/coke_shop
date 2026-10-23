package com.example.cakeshop.util;

import com.example.cakeshop.constant.SessionKeys;
import com.example.cakeshop.model.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.logging.Logger;

/**
 * 会话主体读取：鉴权判定已集中到 AccessControlFilter，业务代码只取当前用户。
 */
public final class SessionUtil {

    private static final Logger log = Logger.getLogger(SessionUtil.class.getName());
    private static final Integer ADMIN_ROLE = 1;

    private SessionUtil() {
    }

    public static User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object principal = session.getAttribute(SessionKeys.USER);
        if (principal == null) {
            return null;
        }
        if (!(principal instanceof User)) {
            log.warning("会话属性 " + SessionKeys.USER + " 类型异常: " + principal.getClass().getName());
            session.removeAttribute(SessionKeys.USER);
            return null;
        }
        return (User) principal;
    }

    public static Integer currentUserId(HttpServletRequest request) {
        User user = currentUser(request);
        return user == null ? null : user.getId();
    }

    public static boolean isAdmin(User user) {
        if (user == null) {
            return false;
        }
        return ADMIN_ROLE.equals(user.getRole()) || "admin".equals(user.getUsername());
    }
}
