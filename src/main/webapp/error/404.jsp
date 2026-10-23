<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - 页面不存在</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
    </style>
</head>
<body>
    <div class="container text-center">
        <div class="card border-0 shadow-lg" style="border-radius: 20px;">
            <div class="card-body py-5">
                <h1 class="display-1 text-danger fw-bold">404</h1>
                <h2 class="mb-3">页面不存在</h2>
                <p class="text-muted mb-4">抱歉，您访问的页面不存在或已被移除</p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-danger">
                        <i class="bi bi-house"></i> 返回首页
                    </a>
                    <a href="javascript:history.back()" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> 返回上一页
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
