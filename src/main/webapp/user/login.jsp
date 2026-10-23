<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - 蛋糕商城</title>
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
        .login-card {
            max-width: 400px;
            width: 100%;
            margin: 0 auto;
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        }
        .login-header {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            color: white;
            border-radius: 16px 16px 0 0;
            padding: 30px;
            text-align: center;
        }
        .login-header h2 {
            margin: 0;
            font-weight: bold;
        }
        .login-header p {
            margin: 10px 0 0;
            opacity: 0.9;
        }
        .form-control {
            border-radius: 8px;
            padding: 12px 15px;
        }
        .btn-login {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-weight: bold;
        }
        .btn-login:hover {
            background: linear-gradient(135deg, #ee5a24 0%, #ff6b6b 100%);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card login-card">
            <div class="login-header">
                <h2><i class="bi bi-cake2"></i> 蛋糕商城</h2>
                <p>欢迎回来，请登录您的账号</p>
            </div>
            <div class="card-body p-4">
                <form id="loginForm">
                    <div class="mb-3">
                        <label for="username" class="form-label">用户名</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" id="username" name="username" placeholder="请输入用户名" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">密码</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="password" placeholder="请输入密码" required>
                            <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="rememberMe">
                        <label class="form-check-label" for="rememberMe">记住我</label>
                    </div>
                    <div class="d-grid mb-3">
                        <button type="submit" class="btn btn-danger btn-login">登录</button>
                    </div>
                    <div class="text-center">
                        <span class="text-muted">还没有账号？</span>
                        <a href="${pageContext.request.contextPath}/user/register.jsp" class="text-danger text-decoration-none">立即注册</a>
                    </div>
                </form>
            </div>
        </div>
        <div class="text-center mt-3">
            <a href="${pageContext.request.contextPath}/" class="text-white text-decoration-none">
                <i class="bi bi-arrow-left"></i> 返回首页
            </a>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            // 登录表单提交
            $('#loginForm').submit(function(e) {
                e.preventDefault();

                var username = $('#username').val().trim();
                var password = $('#password').val().trim();

                if (!username) {
                    alert('请输入用户名');
                    return;
                }
                if (!password) {
                    alert('请输入密码');
                    return;
                }

                // 禁用按钮
                var btn = $(this).find('button[type="submit"]');
                btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 登录中...');

                $.ajax({
                    url: '${pageContext.request.contextPath}/api/user/login',
                    type: 'POST',
                    data: {
                        username: username,
                        password: password
                    },
                    success: function(res) {
                        if (res.code === 200) {
                            // 登录成功
                            alert('登录成功');
                            location.href = '${pageContext.request.contextPath}/';
                        } else {
                            alert(res.msg || '登录失败');
                            btn.prop('disabled', false).html('登录');
                        }
                    },
                    error: function() {
                        alert('网络错误，请稍后重试');
                        btn.prop('disabled', false).html('登录');
                    }
                });
            });

            // 显示/隐藏密码
            $('#togglePassword').click(function() {
                var input = $('#password');
                var icon = $(this).find('i');
                if (input.attr('type') === 'password') {
                    input.attr('type', 'text');
                    icon.removeClass('bi-eye').addClass('bi-eye-slash');
                } else {
                    input.attr('type', 'password');
                    icon.removeClass('bi-eye-slash').addClass('bi-eye');
                }
            });
        });
    </script>
</body>
</html>
