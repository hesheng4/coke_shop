package com.example.cakeshop.util;

import com.example.cakeshop.model.User;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 已登录会话登记表：管理员禁用账号时据此即时吊销该用户的会话。
 */
public final class SessionRegistry {

    private static final Map<String, HttpSession> SESSIONS = new ConcurrentHashMap<>();
    private static final Map<String, Integer> OWNERS = new ConcurrentHashMap<>();

    private SessionRegistry() {
    }

    public static void register(User user, HttpSession session) {
        if (user == null || user.getId() == null || session == null) {
            return;
        }
        SESSIONS.put(session.getId(), session);
        OWNERS.put(session.getId(), user.getId());
    }

    public static void unregister(HttpSession session) {
        if (session == null) {
            return;
        }
        SESSIONS.remove(session.getId());
        OWNERS.remove(session.getId());
    }

    /** 吊销该用户的全部会话，返回被踢下线的会话数。 */
    public static int logout(Integer userId) {
        if (userId == null) {
            return 0;
        }
        int count = 0;
        for (String sessionId : new ArrayList<>(OWNERS.keySet())) {
            if (!userId.equals(OWNERS.get(sessionId))) {
                continue;
            }
            OWNERS.remove(sessionId);
            HttpSession session = SESSIONS.remove(sessionId);
            if (session == null) {
                continue;
            }
            try {
                session.invalidate();
                count++;
            } catch (IllegalStateException ignored) {
                // 会话已先行过期或注销
            }
        }
        return count;
    }
}
