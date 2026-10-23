<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - 服务器错误</title>
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
                <h1 class="display-1 text-danger fw-bold">500</h1>
                <h2 class="mb-3">服务器错误</h2>
                <p class="text-muted mb-4">抱歉，服务器出现了问题，请稍后再试</p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-danger">
                        <i class="bi bi-house"></i> 返回首页
                    </a>
                    <a href="javascript:location.reload()" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-clockwise"></i> 刷新页面
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
