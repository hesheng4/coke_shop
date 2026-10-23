<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单详情 - 蛋糕商城</title>
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
            <!-- 面包屑导航 -->
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">首页</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/order/list.jsp" class="text-decoration-none">我的订单</a></li>
                    <li class="breadcrumb-item active">订单详情</li>
                </ol>
            </nav>

            <!-- 订单信息 -->
            <div id="orderInfo">
                <!-- 动态加载 -->
            </div>

            <!-- 加载状态 -->
            <div class="loading" id="loadingState">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">加载中...</span>
                </div>
            </div>
        </div>
    </main>

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

            // 获取订单ID
            var orderId = getUrlParam('id');
            if (!orderId) {
                alert('订单ID不存在');
                location.href = '${pageContext.request.contextPath}/order/list.jsp';
                return;
            }

            // 加载订单详情
            loadOrderDetail(orderId);
        });

        function loadOrderDetail(orderId) {
            $('#loadingState').show();
            $('#orderInfo').hide();

            $.get('${pageContext.request.contextPath}/api/order/detail', {id: orderId}, function(res) {
                $('#loadingState').hide();

                if (res.code === 200 && res.data) {
                    renderOrderDetail(res.data);
                    $('#orderInfo').show();
                } else {
                    alert('订单不存在');
                    location.href = '${pageContext.request.contextPath}/order/list.jsp';
                }
            }).fail(function() {
                $('#loadingState').hide();
                alert('加载订单信息失败');
            });
        }

        function renderOrderDetail(order) {
            var html = '';

            // 订单状态
            html += '<div class="card border-0 shadow-sm mb-4">';
            html += '  <div class="card-body text-center py-5">';
            html += '    <h3 class="mb-3">' + getOrderStatusText(order.status) + '</h3>';

            if (order.status === 0) {
                html += '    <p class="text-muted">请尽快完成支付，订单将自动取消</p>';
                html += '    <button class="btn btn-danger btn-lg" onclick="payOrder(' + order.id + ')">立即付款</button>';
            } else if (order.status === 1) {
                html += '    <p class="text-muted">商家正在准备商品，请耐心等待</p>';
            } else if (order.status === 2) {
                html += '    <p class="text-muted">商品已发出，请注意查收</p>';
                html += '    <button class="btn btn-danger btn-lg" onclick="confirmReceive(' + order.id + ')">确认收货</button>';
            } else if (order.status === 3) {
                html += '    <p class="text-muted">感谢您的购买，欢迎再次光临</p>';
            } else if (order.status === 4) {
                html += '    <p class="text-muted">订单已取消</p>';
            }

            html += '  </div>';
            html += '</div>';

            // 订单信息
            html += '<div class="row">';
            html += '  <div class="col-md-8">';
            html += '    <div class="card border-0 shadow-sm mb-4">';
            html += '      <div class="card-header bg-white">';
            html += '        <h5 class="mb-0">订单信息</h5>';
            html += '      </div>';
            html += '      <div class="card-body">';
            html += '        <div class="row mb-3">';
            html += '          <div class="col-3 text-muted">订单编号</div>';
            html += '          <div class="col-9">' + esc(order.orderNo) + '</div>';
            html += '        </div>';
            html += '        <div class="row mb-3">';
            html += '          <div class="col-3 text-muted">下单时间</div>';
            html += '          <div class="col-9">' + formatDate(order.createTime) + '</div>';
            html += '        </div>';
            if (order.payTime) {
                html += '        <div class="row mb-3">';
                html += '          <div class="col-3 text-muted">支付时间</div>';
                html += '          <div class="col-9">' + formatDate(order.payTime) + '</div>';
                html += '        </div>';
            }
            if (order.deliveryTime) {
                html += '        <div class="row mb-3">';
                html += '          <div class="col-3 text-muted">配送时间</div>';
                html += '          <div class="col-9">' + esc(order.deliveryTime) + '</div>';
                html += '        </div>';
            }
            if (order.remark) {
                html += '        <div class="row mb-3">';
                html += '          <div class="col-3 text-muted">备注</div>';
                html += '          <div class="col-9">' + esc(order.remark) + '</div>';
                html += '        </div>';
            }
            html += '      </div>';
            html += '    </div>';

            // 收货信息
            html += '    <div class="card border-0 shadow-sm mb-4">';
            html += '      <div class="card-header bg-white">';
            html += '        <h5 class="mb-0">收货信息</h5>';
            html += '      </div>';
            html += '      <div class="card-body">';
            html += '        <div class="row mb-3">';
            html += '          <div class="col-3 text-muted">收货人</div>';
            html += '          <div class="col-9">' + esc(order.receiverName) + '</div>';
            html += '        </div>';
            html += '        <div class="row mb-3">';
            html += '          <div class="col-3 text-muted">联系电话</div>';
            html += '          <div class="col-9">' + esc(order.receiverPhone) + '</div>';
            html += '        </div>';
            html += '        <div class="row mb-3">';
            html += '          <div class="col-3 text-muted">收货地址</div>';
            html += '          <div class="col-9">' + esc(order.receiverAddress) + '</div>';
            html += '        </div>';
            html += '      </div>';
            html += '    </div>';
            html += '  </div>';

            // 订单金额
            html += '  <div class="col-md-4">';
            html += '    <div class="card border-0 shadow-sm mb-4">';
            html += '      <div class="card-header bg-white">';
            html += '        <h5 class="mb-0">订单金额</h5>';
            html += '      </div>';
            html += '      <div class="card-body">';
            html += '        <div class="d-flex justify-content-between mb-2">';
            html += '          <span class="text-muted">商品总价</span>';
            html += '          <span>¥' + order.totalAmount.toFixed(2) + '</span>';
            html += '        </div>';
            if (order.discountAmount && order.discountAmount > 0) {
                html += '        <div class="d-flex justify-content-between mb-2">';
                html += '          <span class="text-muted">优惠金额</span>';
                html += '          <span class="text-danger">-¥' + order.discountAmount.toFixed(2) + '</span>';
                html += '        </div>';
            }
            html += '        <hr>';
            html += '        <div class="d-flex justify-content-between">';
            html += '          <span class="fw-bold">实付金额</span>';
            html += '          <span class="text-danger fs-4 fw-bold">¥' + order.payAmount.toFixed(2) + '</span>';
            html += '        </div>';
            html += '      </div>';
            html += '    </div>';

            // 操作按钮
            html += '    <div class="card border-0 shadow-sm">';
            html += '      <div class="card-body">';
            html += '        <a href="${pageContext.request.contextPath}/order/list.jsp" class="btn btn-outline-secondary w-100 mb-2">返回订单列表</a>';
            if (order.status === 0) {
                html += '        <button class="btn btn-outline-danger w-100" onclick="cancelOrder(' + order.id + ')">取消订单</button>';
            }
            html += '      </div>';
            html += '    </div>';
            html += '  </div>';
            html += '</div>';

            // 订单商品
            html += '<div class="card border-0 shadow-sm mt-4">';
            html += '  <div class="card-header bg-white">';
            html += '    <h5 class="mb-0">订单商品</h5>';
            html += '  </div>';
            html += '  <div class="card-body p-0">';
            html += '    <table class="table table-hover mb-0">';
            html += '      <thead class="bg-light">';
            html += '        <tr>';
            html += '          <th>商品信息</th>';
            html += '          <th width="120">单价</th>';
            html += '          <th width="80">数量</th>';
            html += '          <th width="120">小计</th>';
            html += '        </tr>';
            html += '      </thead>';
            html += '      <tbody>';

            if (order.items && order.items.length > 0) {
                order.items.forEach(function(item) {
                    html += '        <tr>';
                    html += '          <td>';
                    html += '            <div class="d-flex align-items-center">';
                    html += '              <img src="' + esc(productImg(item.productImage)) + '" class="rounded me-3" style="width: 60px; height: 60px; object-fit: cover;" onerror="this.onerror=null;this.src=defaultProductImg">';
                    html += '              <div>';
                    html += '                <h6 class="mb-0"><a href="${pageContext.request.contextPath}/product/detail.jsp?id=' + item.productId + '" class="text-decoration-none text-dark">' + esc(item.productName) + '</a></h6>';
                    if (item.specName) {
                        html += '                <small class="text-muted">' + esc(item.specName) + '</small>';
                    }
                    html += '              </div>';
                    html += '            </div>';
                    html += '          </td>';
                    html += '          <td class="align-middle">¥' + item.price.toFixed(2) + '</td>';
                    html += '          <td class="align-middle">x' + item.quantity + '</td>';
                    html += '          <td class="align-middle text-danger fw-bold">¥' + item.totalPrice.toFixed(2) + '</td>';
                    html += '        </tr>';
                });
            }

            html += '      </tbody>';
            html += '    </table>';
            html += '  </div>';
            html += '</div>';

            $('#orderInfo').html(html);
        }

        function payOrder(orderId) {
            if (!confirm('确定要支付该订单吗？')) {
                return;
            }

            $.post('${pageContext.request.contextPath}/api/order/pay', {orderId: orderId}, function(res) {
                if (res.code === 200) {
                    showToast('支付成功');
                    loadOrderDetail(orderId);
                } else {
                    alert(res.msg || '支付失败');
                }
            });
        }

        function cancelOrder(orderId) {
            if (!confirm('确定要取消该订单吗？')) {
                return;
            }

            $.post('${pageContext.request.contextPath}/api/order/cancel', {orderId: orderId}, function(res) {
                if (res.code === 200) {
                    showToast('订单已取消');
                    loadOrderDetail(orderId);
                } else {
                    alert(res.msg || '取消失败');
                }
            });
        }

        function confirmReceive(orderId) {
            if (!confirm('确定已收到商品吗？')) {
                return;
            }

            $.post('${pageContext.request.contextPath}/api/order/confirm', {orderId: orderId}, function(res) {
                if (res.code === 200) {
                    showToast('已确认收货');
                    loadOrderDetail(orderId);
                } else {
                    alert(res.msg || '确认收货失败');
                }
            });
        }
    </script>
</body>
</html>
