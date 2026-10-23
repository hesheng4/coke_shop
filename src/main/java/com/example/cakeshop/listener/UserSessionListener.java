package com.example.cakeshop.listener;

import com.example.cakeshop.constant.SessionKeys;
import com.example.cakeshop.model.User;
import com.example.cakeshop.util.SessionRegistry;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

/**
 * 跟踪 session 中的登录用户，供管理员禁用账号时即时吊销会话。
 */
@WebListener
public class UserSessionListener implements HttpSessionListener, HttpSessionAttributeListener {

    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        track(event);
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) {
        track(event);
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) {
        if (SessionKeys.USER.equals(event.getName())) {
            SessionRegistry.unregister(event.getSession());
        }
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // 登录成功写入 user 属性时才登记，此处无需处理
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        SessionRegistry.unregister(se.getSession());
    }

    private void track(HttpSessionBindingEvent event) {
        if (!SessionKeys.USER.equals(event.getName())) {
            return;
        }
        // attributeReplaced 事件的 getValue() 返回被替换掉的旧值，必须从会话本身取当前值
        HttpSession session = event.getSession();
        Object value = session.getAttribute(SessionKeys.USER);
        if (value instanceof User) {
            SessionRegistry.register((User) value, session);
        } else {
            SessionRegistry.unregister(session);
        }
    }
}
