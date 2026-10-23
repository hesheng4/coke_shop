package com.example.cakeshop.filter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.Enumeration;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Logger;

/**
 * Servlet 规范只要求容器解析 POST 表单体，Tomcat 对 PUT/DELETE 的请求体不做解析。
 * 前端用 PUT/DELETE 提交参数，这里把 x-www-form-urlencoded 请求体并入 getParameter 结果。
 */
public class FormBodyParamFilter implements Filter {

    private static final String FORM_ENCODING = "application/x-www-form-urlencoded";
    private static final int MAX_BODY_BYTES = 64 * 1024;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        if (parsesFormBody(httpRequest.getMethod()) && isFormUrlEncoded(httpRequest.getContentType())) {
            chain.doFilter(new FormBodyRequest(httpRequest), response);
            return;
        }
        chain.doFilter(request, response);
    }

    private boolean parsesFormBody(String method) {
        return "PUT".equalsIgnoreCase(method) || "DELETE".equalsIgnoreCase(method) || "PATCH".equalsIgnoreCase(method);
    }

    private boolean isFormUrlEncoded(String contentType) {
        return contentType != null && contentType.toLowerCase().startsWith(FORM_ENCODING);
    }

    private static final class FormBodyRequest extends HttpServletRequestWrapper {

        private static final Logger log = Logger.getLogger(FormBodyParamFilter.class.getName());

        private Map<String, String[]> parameters;

        private FormBodyRequest(HttpServletRequest request) {
            super(request);
        }

        @Override
        public String getParameter(String name) {
            String[] values = parameters().get(name);
            return values == null || values.length == 0 ? null : values[0];
        }

        @Override
        public String[] getParameterValues(String name) {
            return parameters().get(name);
        }

        @Override
        public Enumeration<String> getParameterNames() {
            return Collections.enumeration(parameters().keySet());
        }

        @Override
        public Map<String, String[]> getParameterMap() {
            return parameters();
        }

        private Map<String, String[]> parameters() {
            if (parameters == null) {
                Map<String, String[]> merged = new LinkedHashMap<>(super.getParameterMap());
                for (Map.Entry<String, String> entry : readBody().entrySet()) {
                    if (!merged.containsKey(entry.getKey())) {
                        merged.put(entry.getKey(), new String[]{entry.getValue()});
                    }
                }
                parameters = Collections.unmodifiableMap(merged);
            }
            return parameters;
        }

        private Map<String, String> readBody() {
            Map<String, String> body = new LinkedHashMap<>();
            byte[] raw;
            try {
                raw = readAll();
            } catch (IOException e) {
                log.warning("读取请求体失败: " + e.getMessage());
                return body;
            }
            Charset charset = bodyCharset();
            int start = 0;
            while (true) {
                int amp = indexOf(raw, (byte) '&', start);
                addPair(body, raw, start, amp < 0 ? raw.length : amp, charset);
                if (amp < 0) {
                    return body;
                }
                start = amp + 1;
            }
        }

        /** 与容器解析 POST 表单体一致：按字节切分，未编码字节用请求字符集还原，%XX 序列先还原成字节。 */
        private void addPair(Map<String, String> body, byte[] raw, int from, int to, Charset charset) {
            if (from >= to) {
                return;
            }
            int eq = indexOf(raw, (byte) '=', from);
            int nameEnd = eq < 0 ? to : eq;
            try {
                String name = decode(raw, from, nameEnd, charset);
                String value = eq < 0 ? "" : decode(raw, eq + 1, to, charset);
                body.put(name, value);
            } catch (IOException e) {
                log.warning("忽略无法解析的请求体参数: " + e.getMessage());
            }
        }

        private Charset bodyCharset() {
            String encoding = getCharacterEncoding();
            if (encoding == null) {
                return StandardCharsets.UTF_8;
            }
            try {
                return Charset.forName(encoding);
            } catch (Exception e) {
                return StandardCharsets.UTF_8;
            }
        }

        private static String decode(byte[] raw, int from, int to, Charset charset) throws IOException {
            ByteArrayOutputStream out = new ByteArrayOutputStream(to - from);
            for (int i = from; i < to; i++) {
                byte b = raw[i];
                if (b == '+') {
                    out.write(' ');
                } else if (b == '%' && i + 2 < to) {
                    int high = Character.digit((char) raw[i + 1], 16);
                    int low = Character.digit((char) raw[i + 2], 16);
                    if (high < 0 || low < 0) {
                        throw new IOException("非法的百分号编码");
                    }
                    out.write((byte) ((high << 4) + low));
                    i += 2;
                } else {
                    out.write(b);
                }
            }
            return new String(out.toByteArray(), charset);
        }

        private static int indexOf(byte[] data, byte target, int from) {
            for (int i = from; i < data.length; i++) {
                if (data[i] == target) {
                    return i;
                }
            }
            return -1;
        }

        private byte[] readAll() throws IOException {
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            byte[] chunk = new byte[4096];
            int total = 0;
            int read;
            try (InputStream input = getInputStream()) {
                while ((read = input.read(chunk)) != -1) {
                    total += read;
                    if (total > MAX_BODY_BYTES) {
                        throw new UnsupportedEncodingException("请求体超过 " + MAX_BODY_BYTES + " 字节");
                    }
                    buffer.write(chunk, 0, read);
                }
            }
            return buffer.toByteArray();
        }
    }
}
