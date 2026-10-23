<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - 蛋糕商城</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold text-danger" href="${pageContext.request.contextPath}/">
                <i class="bi bi-cake2"></i> 蛋糕商城
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">首页</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/product/list.jsp">全部商品</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart/cart.jsp">
                            <i class="bi bi-cart3"></i> 购物车
                            <span class="badge bg-danger rounded-pill" id="cartCount">0</span>
                        </a>
                    </li>
                    <li class="nav-item dropdown" id="userMenu" style="display: none;">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle"></i> <span id="username"></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile.jsp">个人中心</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/order/list.jsp">我的订单</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#" onclick="logout()">退出登录</a></li>
                        </ul>
                    </li>
                    <li class="nav-item" id="loginBtn">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/login.jsp">
                            <i class="bi bi-box-arrow-in-right"></i> 登录
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 主要内容 -->
    <main style="margin-top: 70px;">
        <div class="container py-4">
            <div class="row">
                <!-- 左侧菜单 -->
                <div class="col-md-3 mb-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body text-center py-5">
                            <div class="mb-3">
                                <i class="bi bi-person-circle display-1 text-muted"></i>
                            </div>
                            <h5 id="profileUsername">用户名</h5>
                            <p class="text-muted mb-0" id="profileEmail">邮箱</p>
                        </div>
                        <div class="list-group list-group-flush">
                            <a href="#userInfo" class="list-group-item list-group-item-action active" data-bs-toggle="tab">
                                <i class="bi bi-person"></i> 个人信息
                            </a>
                            <a href="#addressManage" class="list-group-item list-group-item-action" data-bs-toggle="tab">
                                <i class="bi bi-geo-alt"></i> 收货地址
                            </a>
                            <a href="#changePassword" class="list-group-item list-group-item-action" data-bs-toggle="tab">
                                <i class="bi bi-lock"></i> 修改密码
                            </a>
                            <a href="${pageContext.request.contextPath}/order/list.jsp" class="list-group-item list-group-item-action">
                                <i class="bi bi-receipt"></i> 我的订单
                            </a>
                        </div>
                    </div>
                </div>

                <!-- 右侧内容 -->
                <div class="col-md-9">
                    <div class="tab-content">
                        <!-- 个人信息 -->
                        <div class="tab-pane fade show active" id="userInfo">
                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0">个人信息</h5>
                                </div>
                                <div class="card-body">
                                    <form id="profileForm">
                                        <div class="mb-3">
                                            <label class="form-label">用户名</label>
                                            <input type="text" class="form-control" id="editUsername" disabled>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">邮箱</label>
                                            <input type="email" class="form-control" id="editEmail" placeholder="请输入邮箱">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">手机号</label>
                                            <input type="tel" class="form-control" id="editPhone" placeholder="请输入手机号">
                                        </div>
                                        <button type="submit" class="btn btn-danger">保存修改</button>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- 收货地址 -->
                        <div class="tab-pane fade" id="addressManage">
                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">收货地址</h5>
                                    <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#addressModal">
                                        <i class="bi bi-plus"></i> 新增地址
                                    </button>
                                </div>
                                <div class="card-body" id="addressList">
                                    <!-- 动态加载 -->
                                </div>
                            </div>
                        </div>

                        <!-- 修改密码 -->
                        <div class="tab-pane fade" id="changePassword">
                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0">修改密码</h5>
                                </div>
                                <div class="card-body">
                                    <form id="passwordForm">
                                        <div class="mb-3">
                                            <label class="form-label">旧密码 <span class="text-danger">*</span></label>
                                            <input type="password" class="form-control" id="oldPassword" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">新密码 <span class="text-danger">*</span></label>
                                            <input type="password" class="form-control" id="newPassword" required>
                                            <div class="form-text">密码长度至少6位</div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">确认新密码 <span class="text-danger">*</span></label>
                                            <input type="password" class="form-control" id="confirmNewPassword" required>
                                        </div>
                                        <button type="submit" class="btn btn-danger">修改密码</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- 新增地址模态框 -->
    <div class="modal fade" id="addressModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">新增收货地址</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addressForm">
                        <div class="mb-3">
                            <label class="form-label">收货人 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="receiverName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">联系电话 <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" id="receiverPhone" required>
                        </div>
                        <div class="row mb-3">
                            <div class="col-4">
                                <label class="form-label">省 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="province" required>
                            </div>
                            <div class="col-4">
                                <label class="form-label">市 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="city" required>
                            </div>
                            <div class="col-4">
                                <label class="form-label">区 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="district" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">详细地址 <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="detailAddress" rows="2" required></textarea>
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="isDefault">
                            <label class="form-check-label" for="isDefault">设为默认地址</label>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-danger" onclick="saveAddress()">保存</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 页脚 -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h5>关于我们</h5>
                    <p class="text-muted">蛋糕商城，为您提供最新鲜、最美味的蛋糕。</p>
                </div>
                <div class="col-md-2 mb-3">
                    <h5>快速链接</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/" class="text-muted text-decoration-none">首页</a></li>
                        <li><a href="${pageContext.request.contextPath}/product/list.jsp" class="text-muted text-decoration-none">全部商品</a></li>
                    </ul>
                </div>
                <div class="col-md-3 mb-3">
                    <h5>联系方式</h5>
                    <ul class="list-unstyled text-muted">
                        <li><i class="bi bi-telephone"></i> 400-123-4567</li>
                        <li><i class="bi bi-envelope"></i> service@cakeshop.com</li>
                    </ul>
                </div>
                <div class="col-md-3 mb-3">
                    <h5>关注我们</h5>
                    <div class="d-flex gap-3">
                        <a href="#" class="text-muted fs-4"><i class="bi bi-wechat"></i></a>
                        <a href="#" class="text-muted fs-4"><i class="bi bi-tencent-qq"></i></a>
                    </div>
                </div>
            </div>
            <hr class="my-3">
            <div class="text-center text-muted">
                <p class="mb-0">&copy; 2024 蛋糕商城 All Rights Reserved</p>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script>
        $(document).ready(function() {
            // 检查登录状态
            checkLoginStatus();

            // 加载用户信息
            loadUserInfo();

            // 加载地址列表
            loadAddresses();

            // 个人信息表单提交
            $('#profileForm').submit(function(e) {
                e.preventDefault();
                updateProfile();
            });

            // 密码表单提交
            $('#passwordForm').submit(function(e) {
                e.preventDefault();
                updatePassword();
            });
        });

        function loadUserInfo() {
            $.get('${pageContext.request.contextPath}/api/user/info', function(res) {
                if (res.code === 200 && res.data) {
                    var user = res.data;
                    $('#profileUsername').text(user.username);
                    $('#profileEmail').text(user.email || '未设置邮箱');
                    $('#editUsername').val(user.username);
                    $('#editEmail').val(user.email || '');
                    $('#editPhone').val(user.phone || '');
                }
            });
        }

        function updateProfile() {
            var email = $('#editEmail').val().trim();
            var phone = $('#editPhone').val().trim();

            $.ajax({
                url: '${pageContext.request.contextPath}/api/user/info',
                type: 'PUT',
                data: {
                    email: email,
                    phone: phone
                },
                success: function(res) {
                    if (res.code === 200) {
                        showToast('个人信息更新成功');
                        loadUserInfo();
                    } else {
                        alert(res.msg || '更新失败');
                    }
                },
                error: function() {
                    alert('网络错误，请稍后重试');
                }
            });
        }

        function updatePassword() {
            var oldPassword = $('#oldPassword').val().trim();
            var newPassword = $('#newPassword').val().trim();
            var confirmNewPassword = $('#confirmNewPassword').val().trim();

            if (!oldPassword || !newPassword || !confirmNewPassword) {
                alert('请填写完整信息');
                return;
            }

            if (newPassword.length < 6) {
                alert('新密码长度至少6位');
                return;
            }

            if (newPassword !== confirmNewPassword) {
                alert('两次输入的新密码不一致');
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/api/user/password',
                type: 'PUT',
                data: {
                    oldPassword: oldPassword,
                    newPassword: newPassword
                },
                success: function(res) {
                    if (res.code === 200) {
                        showToast('密码修改成功');
                        $('#passwordForm')[0].reset();
                    } else {
                        alert(res.msg || '修改失败');
                    }
                },
                error: function() {
                    alert('网络错误，请稍后重试');
                }
            });
        }

        function loadAddresses() {
            $.get('${pageContext.request.contextPath}/api/user/address', function(res) {
                if (res.code === 200 && res.data && res.data.length > 0) {
                    renderAddresses(res.data);
                } else {
                    $('#addressList').html('<p class="text-muted mb-0">暂无收货地址，请新增</p>');
                }
            });
        }

        function renderAddresses(addresses) {
            var html = '<div class="list-group">';
            addresses.forEach(function(addr) {
                html += '<div class="list-group-item">';
                html += '  <div class="d-flex justify-content-between align-items-start">';
                html += '    <div>';
                html += '      <h6 class="mb-1">' + esc(addr.receiverName) + ' ' + esc(addr.receiverPhone) + '</h6>';
                html += '      <p class="mb-0 text-muted">' + esc('' + addr.province + addr.city + addr.district + addr.detailAddress) + '</p>';
                if (addr.isDefault === 1) {
                    html += '      <span class="badge bg-danger mt-1">默认</span>';
                }
                html += '    </div>';
                html += '    <div>';
                html += '      <button class="btn btn-outline-danger btn-sm me-1" onclick="setDefaultAddress(' + addr.id + ')">设为默认</button>';
                html += '      <button class="btn btn-outline-secondary btn-sm" onclick="deleteAddress(' + addr.id + ')">删除</button>';
                html += '    </div>';
                html += '  </div>';
                html += '</div>';
            });
            html += '</div>';
            $('#addressList').html(html);
        }

        function saveAddress() {
            var receiverName = $('#receiverName').val().trim();
            var receiverPhone = $('#receiverPhone').val().trim();
            var province = $('#province').val().trim();
            var city = $('#city').val().trim();
            var district = $('#district').val().trim();
            var detailAddress = $('#detailAddress').val().trim();
            var isDefault = $('#isDefault').is(':checked') ? 1 : 0;

            if (!receiverName || !receiverPhone || !province || !city || !district || !detailAddress) {
                alert('请填写完整地址信息');
                return;
            }

            $.post('${pageContext.request.contextPath}/api/user/address', {
                receiverName: receiverName,
                receiverPhone: receiverPhone,
                province: province,
                city: city,
                district: district,
                detailAddress: detailAddress,
                isDefault: isDefault
            }, function(res) {
                if (res.code === 200) {
                    showToast('地址添加成功');
                    $('#addressModal').modal('hide');
                    $('#addressForm')[0].reset();
                    loadAddresses();
                } else {
                    alert(res.msg || '添加失败');
                }
            });
        }

        function setDefaultAddress(id) {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/user/address/' + id,
                type: 'PUT',
                data: {isDefault: 1},
                success: function(res) {
                    if (res.code === 200) {
                        showToast('已设为默认地址');
                        loadAddresses();
                    } else {
                        alert(res.msg || '设置失败');
                    }
                }
            });
        }

        function deleteAddress(id) {
            if (!confirm('确定要删除该地址吗？')) {
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/api/user/address/' + id,
                type: 'DELETE',
                success: function(res) {
                    if (res.code === 200) {
                        showToast('地址已删除');
                        loadAddresses();
                    } else {
                        alert(res.msg || '删除失败');
                    }
                }
            });
        }
    </script>
</body>
</html>
