<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册 - 蛋糕商城</title>
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
        .register-card {
            max-width: 450px;
            width: 100%;
            margin: 0 auto;
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        }
        .register-header {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            color: white;
            border-radius: 16px 16px 0 0;
            padding: 30px;
            text-align: center;
        }
        .register-header h2 {
            margin: 0;
            font-weight: bold;
        }
        .register-header p {
            margin: 10px 0 0;
            opacity: 0.9;
        }
        .form-control {
            border-radius: 8px;
            padding: 12px 15px;
        }
        .btn-register {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-weight: bold;
        }
        .btn-register:hover {
            background: linear-gradient(135deg, #ee5a24 0%, #ff6b6b 100%);
        }
        .password-strength {
            height: 4px;
            margin-top: 5px;
            border-radius: 2px;
            transition: all 0.3s;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card register-card">
            <div class="register-header">
                <h2><i class="bi bi-cake2"></i> 蛋糕商城</h2>
                <p>创建新账号，开启甜蜜之旅</p>
            </div>
            <div class="card-body p-4">
                <form id="registerForm">
                    <div class="mb-3">
                        <label for="username" class="form-label">用户名 <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" id="username" name="username" placeholder="请输入用户名" required>
                        </div>
                        <div class="form-text">用户名长度为3-20个字符</div>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">密码 <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="password" placeholder="请输入密码" required>
                            <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="password-strength" id="passwordStrength"></div>
                        <div class="form-text">密码长度至少6位</div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">确认密码 <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="请再次输入密码" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">邮箱</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email" placeholder="请输入邮箱">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">手机号</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-phone"></i></span>
                            <input type="tel" class="form-control" id="phone" name="phone" placeholder="请输入手机号">
                        </div>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="agreeTerms" required>
                        <label class="form-check-label" for="agreeTerms">
                            我已阅读并同意 <a href="#" class="text-danger">《用户协议》</a> 和 <a href="#" class="text-danger">《隐私政策》</a>
                        </label>
                    </div>
                    <div class="d-grid mb-3">
                        <button type="submit" class="btn btn-danger btn-register">注册</button>
                    </div>
                    <div class="text-center">
                        <span class="text-muted">已有账号？</span>
                        <a href="${pageContext.request.contextPath}/user/login.jsp" class="text-danger text-decoration-none">立即登录</a>
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
            // 注册表单提交
            $('#registerForm').submit(function(e) {
                e.preventDefault();

                var username = $('#username').val().trim();
                var password = $('#password').val().trim();
                var confirmPassword = $('#confirmPassword').val().trim();
                var email = $('#email').val().trim();
                var phone = $('#phone').val().trim();

                // 验证
                if (!username) {
                    alert('请输入用户名');
                    return;
                }
                if (username.length < 3 || username.length > 20) {
                    alert('用户名长度应为3-20个字符');
                    return;
                }
                if (!password) {
                    alert('请输入密码');
                    return;
                }
                if (password.length < 6) {
                    alert('密码长度至少6位');
                    return;
                }
                if (password !== confirmPassword) {
                    alert('两次输入的密码不一致');
                    return;
                }
                if (!$('#agreeTerms').is(':checked')) {
                    alert('请同意用户协议和隐私政策');
                    return;
                }

                // 禁用按钮
                var btn = $(this).find('button[type="submit"]');
                btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 注册中...');

                $.ajax({
                    url: '${pageContext.request.contextPath}/api/user/register',
                    type: 'POST',
                    data: {
                        username: username,
                        password: password,
                        email: email,
                        phone: phone
                    },
                    success: function(res) {
                        if (res.code === 200) {
                            alert('注册成功，请登录');
                            location.href = '${pageContext.request.contextPath}/user/login.jsp';
                        } else {
                            alert(res.msg || '注册失败');
                            btn.prop('disabled', false).html('注册');
                        }
                    },
                    error: function() {
                        alert('网络错误，请稍后重试');
                        btn.prop('disabled', false).html('注册');
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

            // 密码强度检测
            $('#password').on('input', function() {
                var password = $(this).val();
                var strength = 0;
                var strengthBar = $('#passwordStrength');

                if (password.length >= 6) strength++;
                if (password.length >= 8) strength++;
                if (/[A-Z]/.test(password)) strength++;
                if (/[a-z]/.test(password)) strength++;
                if (/[0-9]/.test(password)) strength++;
                if (/[^A-Za-z0-9]/.test(password)) strength++;

                var colors = ['#dc3545', '#fd7e14', '#ffc107', '#20c997', '#198754'];
                var widths = ['20%', '40%', '60%', '80%', '100%'];

                if (password.length === 0) {
                    strengthBar.css('width', '0').css('background-color', 'transparent');
                } else if (strength <= 2) {
                    strengthBar.css('width', widths[0]).css('background-color', colors[0]);
                } else if (strength <= 3) {
                    strengthBar.css('width', widths[1]).css('background-color', colors[1]);
                } else if (strength <= 4) {
                    strengthBar.css('width', widths[2]).css('background-color', colors[2]);
                } else if (strength <= 5) {
                    strengthBar.css('width', widths[3]).css('background-color', colors[3]);
                } else {
                    strengthBar.css('width', widths[4]).css('background-color', colors[4]);
                }
            });
        });
    </script>
</body>
</html>
