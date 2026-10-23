package com.example.cakeshop.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 方法 + 路径的路由表，替代控制器里的 if/else 链；支持 {name} 形式的尾部路径变量。
 */
public final class ApiRouter {

    public interface Handler {
        void handle(HttpServletRequest request, HttpServletResponse response) throws Exception;
    }

    private static final String VARIABLE_ATTRIBUTE_PREFIX = "cakeshop.pathVariable.";
    private static final Pattern VARIABLE_SEGMENT = Pattern.compile("\\{([A-Za-z][A-Za-z0-9_]*)\\}");

    private final Map<String, Handler> literalRoutes = new HashMap<>();
    private final List<CompiledRoute> variableRoutes = new ArrayList<>();

    private static final class CompiledRoute {
        private final String method;
        private final Pattern pattern;
        private final List<String> names;
        private final Handler handler;

        private CompiledRoute(String method, Pattern pattern, List<String> names, Handler handler) {
            this.method = method;
            this.pattern = pattern;
            this.names = names;
            this.handler = handler;
        }
    }

    public ApiRouter on(String method, String path, Handler handler) {
        if (path.indexOf('{') < 0) {
            String key = routeKey(method, path);
            if (literalRoutes.containsKey(key)) {
                throw new IllegalStateException("重复路由: " + key);
            }
            literalRoutes.put(key, handler);
            return this;
        }
        List<String> names = new ArrayList<>();
        Matcher matcher = VARIABLE_SEGMENT.matcher(path);
        StringBuffer expression = new StringBuffer();
        while (matcher.find()) {
            String name = matcher.group(1);
            names.add(name);
            matcher.appendReplacement(expression, "(?<" + name + ">[^/]+)");
        }
        matcher.appendTail(expression);
        variableRoutes.add(new CompiledRoute(method.toUpperCase(), Pattern.compile(expression.toString()), names, handler));
        return this;
    }

    public boolean dispatch(String method, String path, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Handler handler = literalRoutes.get(routeKey(method, path));
        if (handler != null) {
            handler.handle(request, response);
            return true;
        }
        for (CompiledRoute route : variableRoutes) {
            if (!route.method.equalsIgnoreCase(method)) {
                continue;
            }
            Matcher matcher = route.pattern.matcher(path);
            if (!matcher.matches()) {
                continue;
            }
            for (String name : route.names) {
                request.setAttribute(VARIABLE_ATTRIBUTE_PREFIX + name, matcher.group(name));
            }
            route.handler.handle(request, response);
            return true;
        }
        return false;
    }

    public static String pathVariable(HttpServletRequest request, String name) {
        Object value = request.getAttribute(VARIABLE_ATTRIBUTE_PREFIX + name);
        return value == null ? null : value.toString();
    }

    private static String routeKey(String method, String path) {
        return method.toUpperCase() + " " + path;
    }
}
