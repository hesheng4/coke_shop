<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>购物车 - 蛋糕商城</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/cart/cart.jsp">
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
                <i class="bi bi-cart3"></i> 我的购物车
            </h2>

            <!-- 购物车列表 -->
            <div id="cartContent">
                <div class="card border-0 shadow-sm">
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th width="50">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="selectAll">
                                        </div>
                                    </th>
                                    <th>商品信息</th>
                                    <th width="120">单价</th>
                                    <th width="150">数量</th>
                                    <th width="120">小计</th>
                                    <th width="80">操作</th>
                                </tr>
                            </thead>
                            <tbody id="cartList">
                                <!-- 动态加载 -->
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 结算栏 -->
                <div class="card border-0 shadow-sm mt-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="form-check d-inline-block me-3">
                                    <input class="form-check-input" type="checkbox" id="selectAllBottom">
                                    <label class="form-check-label" for="selectAllBottom">全选</label>
                                </div>
                                <button class="btn btn-outline-danger btn-sm" onclick="deleteSelected()">
                                    <i class="bi bi-trash"></i> 删除选中
                                </button>
                                <button class="btn btn-outline-secondary btn-sm ms-2" onclick="clearCart()">
                                    <i class="bi bi-trash"></i> 清空购物车
                                </button>
                            </div>
                            <div class="d-flex align-items-center">
                                <span class="text-muted me-3">已选 <span id="selectedCount" class="text-danger fw-bold">0</span> 件商品</span>
                                <span class="text-muted me-3">合计: <span id="totalPrice" class="text-danger fs-4 fw-bold">¥0.00</span></span>
                                <button class="btn btn-danger btn-lg" id="checkoutBtn" onclick="checkout()" disabled>
                                    去结算
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 空购物车 -->
            <div class="empty-state" id="emptyCart" style="display: none;">
                <i class="bi bi-cart-x"></i>
                <h4>购物车是空的</h4>
                <p class="text-muted">快去选购心仪的蛋糕吧</p>
                <a href="${pageContext.request.contextPath}/product/list.jsp" class="btn btn-danger">
                    <i class="bi bi-shop"></i> 去购物
                </a>
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
        var cartItems = [];

        $(document).ready(function() {
            // 检查登录状态
            checkLoginStatus();

            // 加载购物车
            loadCart();

            // 全选事件
            $('#selectAll, #selectAllBottom').change(function() {
                var isChecked = $(this).prop('checked');
                $('#selectAll, #selectAllBottom').prop('checked', isChecked);
                $('.cart-item-checkbox').prop('checked', isChecked);
                updateTotal();
            });
        });

        function loadCart() {
            $('#loadingState').show();
            $('#cartContent').hide();
            $('#emptyCart').hide();

            $.get('${pageContext.request.contextPath}/api/cart/list', function(res) {
                $('#loadingState').hide();

                if (res.code === 200 && res.data && res.data.length > 0) {
                    cartItems = res.data;
                    renderCart(cartItems);
                    $('#cartContent').show();
                } else {
                    $('#emptyCart').show();
                }
            }).fail(function() {
                $('#loadingState').hide();
                alert('加载购物车失败');
            });
        }

        function renderCart(items) {
            var html = '';
            items.forEach(function(item) {
                var price = item.spec && item.spec.price ? item.spec.price : (item.product ? item.product.price : 0);
                var totalPrice = price * item.quantity;
                var specText = item.spec ? (item.spec.specName + ': ' + item.spec.specValue) : '';

                html += '<tr class="cart-item" data-id="' + item.id + '">';
                html += '  <td>';
                html += '    <div class="form-check">';
                html += '      <input class="form-check-input cart-item-checkbox" type="checkbox" value="' + item.id + '" onchange="updateTotal()">';
                html += '    </div>';
                html += '  </td>';
                html += '  <td>';
                html += '    <div class="d-flex align-items-center">';
                html += '      <img src="' + esc(productImg(item.product ? item.product.image : null)) + '" class="rounded me-3" style="width: 80px; height: 80px; object-fit: cover;" onerror="this.onerror=null;this.src=defaultProductImg">';
                html += '      <div>';
                html += '        <h6 class="mb-1"><a href="${pageContext.request.contextPath}/product/detail.jsp?id=' + item.productId + '" class="text-decoration-none text-dark">' + esc(item.product ? item.product.name : '') + '</a></h6>';
                if (specText) {
                    html += '        <small class="text-muted">' + esc(specText) + '</small>';
                }
                html += '      </div>';
                html += '    </div>';
                html += '  </td>';
                html += '  <td class="align-middle">';
                html += '    <span class="text-danger">¥' + price.toFixed(2) + '</span>';
                html += '  </td>';
                html += '  <td class="align-middle">';
                html += '    <div class="d-inline-flex align-items-center">';
                html += '      <button class="btn btn-outline-secondary btn-sm" onclick="changeQuantity(' + item.id + ', ' + (item.quantity - 1) + ')">';
                html += '        <i class="bi bi-dash"></i>';
                html += '      </button>';
                html += '      <input type="number" class="form-control form-control-sm quantity-input mx-1" value="' + item.quantity + '" min="1" max="99" onchange="changeQuantity(' + item.id + ', this.value)">';
                html += '      <button class="btn btn-outline-secondary btn-sm" onclick="changeQuantity(' + item.id + ', ' + (item.quantity + 1) + ')">';
                html += '        <i class="bi bi-plus"></i>';
                html += '      </button>';
                html += '    </div>';
                html += '  </td>';
                html += '  <td class="align-middle">';
                html += '    <span class="text-danger fw-bold">¥' + totalPrice.toFixed(2) + '</span>';
                html += '  </td>';
                html += '  <td class="align-middle">';
                html += '    <button class="btn btn-outline-danger btn-sm" onclick="deleteItem(' + item.id + ')">';
                html += '      <i class="bi bi-trash"></i>';
                html += '    </button>';
                html += '  </td>';
                html += '</tr>';
            });

            $('#cartList').html(html);
            updateTotal();
        }

        function changeQuantity(cartId, newQuantity) {
            newQuantity = parseInt(newQuantity);
            if (newQuantity < 1) {
                if (confirm('确定要删除该商品吗？')) {
                    deleteItem(cartId);
                }
                return;
            }
            if (newQuantity > 99) {
                newQuantity = 99;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/api/cart/' + cartId + '?quantity=' + newQuantity,
                type: 'PUT',
                success: function(res) {
                    if (res.code === 200) {
                        loadCart();
                        updateCartCount();
                    } else {
                        alert(res.msg || '更新失败');
                    }
                }
            });
        }

        function deleteItem(cartId) {
            if (!confirm('确定要删除该商品吗？')) {
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/api/cart/' + cartId,
                type: 'DELETE',
                success: function(res) {
                    if (res.code === 200) {
                        showToast('已删除');
                        loadCart();
                        updateCartCount();
                    } else {
                        alert(res.msg || '删除失败');
                    }
                }
            });
        }

        function deleteSelected() {
            var selectedIds = [];
            $('.cart-item-checkbox:checked').each(function() {
                selectedIds.push(parseInt($(this).val()));
            });

            if (selectedIds.length === 0) {
                alert('请选择要删除的商品');
                return;
            }

            if (!confirm('确定要删除选中的商品吗？')) {
                return;
            }

            // 逐个删除
            var deleted = 0;
            selectedIds.forEach(function(id) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/cart/' + id,
                    type: 'DELETE',
                    success: function(res) {
                        deleted++;
                        if (deleted === selectedIds.length) {
                            showToast('已删除选中商品');
                            loadCart();
                            updateCartCount();
                        }
                    }
                });
            });
        }

        function clearCart() {
            if (!confirm('确定要清空购物车吗？')) {
                return;
            }

            // 删除所有商品
            var allIds = cartItems.map(function(item) { return item.id; });
            if (allIds.length === 0) return;

            var deleted = 0;
            allIds.forEach(function(id) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/cart/' + id,
                    type: 'DELETE',
                    success: function(res) {
                        deleted++;
                        if (deleted === allIds.length) {
                            showToast('购物车已清空');
                            loadCart();
                            updateCartCount();
                        }
                    }
                });
            });
        }

        function updateTotal() {
            var selectedCount = 0;
            var totalPrice = 0;

            $('.cart-item-checkbox:checked').each(function() {
                var cartId = $(this).val();
                var item = cartItems.find(function(i) { return i.id == cartId; });
                if (item) {
                    selectedCount++;
                    var price = item.spec && item.spec.price ? item.spec.price : (item.product ? item.product.price : 0);
                    totalPrice += price * item.quantity;
                }
            });

            $('#selectedCount').text(selectedCount);
            $('#totalPrice').text('¥' + totalPrice.toFixed(2));
            $('#checkoutBtn').prop('disabled', selectedCount === 0);
        }

        function checkout() {
            var selectedIds = [];
            $('.cart-item-checkbox:checked').each(function() {
                selectedIds.push($(this).val());
            });

            if (selectedIds.length === 0) {
                alert('请选择要结算的商品');
                return;
            }

            // 跳转到确认订单页面
            location.href = '${pageContext.request.contextPath}/order/confirm.jsp?cartIds=' + selectedIds.join(',');
        }
    </script>
</body>
</html>
