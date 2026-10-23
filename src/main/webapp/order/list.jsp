<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的订单 - 蛋糕商城</title>
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
            <h2 class="mb-4">
                <i class="bi bi-receipt"></i> 我的订单
            </h2>

            <!-- 订单状态筛选 -->
            <ul class="nav nav-tabs mb-4" id="orderTabs">
                <li class="nav-item">
                    <a class="nav-link active" data-status="" href="#">全部订单</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-status="0" href="#">待付款</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-status="1" href="#">待发货</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-status="2" href="#">待收货</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-status="3" href="#">已完成</a>
                </li>
            </ul>

            <!-- 订单列表 -->
            <div id="orderList">
                <!-- 动态加载 -->
            </div>

            <!-- 加载状态 -->
            <div class="loading" id="loadingState">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">加载中...</span>
                </div>
            </div>

            <!-- 空状态 -->
            <div class="empty-state" id="emptyState" style="display: none;">
                <i class="bi bi-receipt"></i>
                <h4>暂无订单</h4>
                <p class="text-muted">快去选购心仪的蛋糕吧</p>
                <a href="${pageContext.request.contextPath}/product/list.jsp" class="btn btn-danger">
                    <i class="bi bi-shop"></i> 去购物
                </a>
            </div>

            <!-- 分页 -->
            <div id="pagination" class="mt-4"></div>
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
        var currentPage = 1;
        var currentStatus = '';

        $(document).ready(function() {
            // 检查登录状态
            checkLoginStatus();

            // 加载订单
            loadOrders();

            // 状态筛选
            $('#orderTabs a').click(function(e) {
                e.preventDefault();
                $('#orderTabs a').removeClass('active');
                $(this).addClass('active');
                currentStatus = $(this).data('status');
                currentPage = 1;
                loadOrders();
            });
        });

        function loadOrders() {
            $('#loadingState').show();
            $('#orderList').hide();
            $('#emptyState').hide();

            var params = {
                page: currentPage,
                pageSize: 10
            };

            if (currentStatus !== '') {
                params.status = currentStatus;
            }

            $.get('${pageContext.request.contextPath}/api/order/list', params, function(res) {
                $('#loadingState').hide();

                if (res.code === 200 && res.data && res.data.list && res.data.list.length > 0) {
                    renderOrders(res.data.list);
                    $('#orderList').show();

                    // 渲染分页
                    var paginationHtml = renderPagination(res.data.page);
                    $('#pagination').html(paginationHtml);
                    bindPaginationEvent('#pagination', function(page) {
                        currentPage = page;
                        loadOrders();
                        $('html, body').animate({scrollTop: 0}, 300);
                    });
                } else {
                    $('#emptyState').show();
                    $('#pagination').html('');
                }
            }).fail(function() {
                $('#loadingState').hide();
                alert('加载订单失败');
            });
        }

        function renderOrders(orders) {
            var html = '';
            orders.forEach(function(order) {
                html += '<div class="card border-0 shadow-sm mb-3">';
                html += '  <div class="card-header bg-white d-flex justify-content-between align-items-center">';
                html += '    <div>';
                html += '      <span class="text-muted">订单号: ' + esc(order.orderNo) + '</span>';
                html += '      <span class="ms-3">' + formatDate(order.createTime) + '</span>';
                html += '    </div>';
                html += '    <span class="status-badge ' + getOrderStatusClass(order.status) + '">' + getOrderStatusText(order.status) + '</span>';
                html += '  </div>';
                html += '  <div class="card-body">';

                // 订单商品
                if (order.items && order.items.length > 0) {
                    order.items.forEach(function(item) {
                        html += '    <div class="d-flex align-items-center mb-2">';
                        html += '      <img src="' + esc(productImg(item.productImage)) + '" class="rounded me-3" style="width: 60px; height: 60px; object-fit: cover;" onerror="this.onerror=null;this.src=defaultProductImg">';
                        html += '      <div class="flex-grow-1">';
                        html += '        <h6 class="mb-0">' + esc(item.productName) + '</h6>';
                        if (item.specName) {
                            html += '        <small class="text-muted">' + esc(item.specName) + '</small>';
                        }
                        html += '      </div>';
                        html += '      <div class="text-end">';
                        html += '        <span class="text-danger">¥' + item.price.toFixed(2) + '</span>';
                        html += '        <small class="text-muted"> x' + item.quantity + '</small>';
                        html += '      </div>';
                        html += '    </div>';
                    });
                }

                html += '  </div>';
                html += '  <div class="card-footer bg-white d-flex justify-content-between align-items-center">';
                html += '    <div>';
                html += '      <span class="text-muted">共 ' + (order.items ? order.items.length : 0) + ' 件商品</span>';
                html += '      <span class="ms-3">实付: <span class="text-danger fw-bold">¥' + order.payAmount.toFixed(2) + '</span></span>';
                html += '    </div>';
                html += '    <div>';

                // 根据订单状态显示不同按钮
                if (order.status === 0) {
                    html += '      <button class="btn btn-outline-danger btn-sm me-2" onclick="cancelOrder(' + order.id + ')">取消订单</button>';
                    html += '      <button class="btn btn-danger btn-sm" onclick="payOrder(' + order.id + ')">立即付款</button>';
                } else if (order.status === 2) {
                    html += '      <button class="btn btn-danger btn-sm" onclick="confirmReceive(' + order.id + ')">确认收货</button>';
                } else if (order.status === 3) {
                    html += '      <a href="${pageContext.request.contextPath}/product/detail.jsp?id=' + (order.items && order.items[0] ? order.items[0].productId : '') + '" class="btn btn-outline-danger btn-sm">再次购买</a>';
                }

                html += '      <a href="${pageContext.request.contextPath}/order/detail.jsp?id=' + order.id + '" class="btn btn-outline-secondary btn-sm ms-2">查看详情</a>';
                html += '    </div>';
                html += '  </div>';
                html += '</div>';
            });

            $('#orderList').html(html);
        }

        function payOrder(orderId) {
            if (!confirm('确定要支付该订单吗？')) {
                return;
            }

            $.post('${pageContext.request.contextPath}/api/order/pay', {orderId: orderId}, function(res) {
                if (res.code === 200) {
                    showToast('支付成功');
                    loadOrders();
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
                    loadOrders();
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
                    loadOrders();
                } else {
                    alert(res.msg || '确认收货失败');
                }
            });
        }
    </script>
</body>
</html>
