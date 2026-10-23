<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>确认订单 - 蛋糕商城</title>
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
                <i class="bi bi-check-circle"></i> 确认订单
            </h2>

            <div class="row">
                <div class="col-md-8">
                    <!-- 收货地址 -->
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">收货地址</h5>
                            <button class="btn btn-outline-danger btn-sm" data-bs-toggle="modal" data-bs-target="#addressModal">
                                <i class="bi bi-plus"></i> 新增地址
                            </button>
                        </div>
                        <div class="card-body" id="addressList">
                            <!-- 动态加载 -->
                        </div>
                    </div>

                    <!-- 配送时间 -->
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">配送时间</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">配送日期</label>
                                    <input type="date" class="form-control" id="deliveryDate" min="">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">配送时段</label>
                                    <select class="form-select" id="deliveryTime">
                                        <option value="09:00-12:00">09:00-12:00</option>
                                        <option value="12:00-15:00">12:00-15:00</option>
                                        <option value="15:00-18:00">15:00-18:00</option>
                                        <option value="18:00-21:00">18:00-21:00</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 订单商品 -->
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">订单商品</h5>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-hover mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th>商品信息</th>
                                        <th width="120">单价</th>
                                        <th width="80">数量</th>
                                        <th width="120">小计</th>
                                    </tr>
                                </thead>
                                <tbody id="orderItems">
                                    <!-- 动态加载 -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- 备注 -->
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">订单备注</h5>
                        </div>
                        <div class="card-body">
                            <textarea class="form-control" id="remark" rows="3" placeholder="请输入备注信息（选填）"></textarea>
                        </div>
                    </div>
                </div>

                <!-- 订单汇总 -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">订单汇总</h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">商品总价</span>
                                <span id="totalAmount">¥0.00</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">运费</span>
                                <span class="text-success">免运费</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between">
                                <span class="fw-bold">应付金额</span>
                                <span class="text-danger fs-4 fw-bold" id="payAmount">¥0.00</span>
                            </div>
                        </div>
                    </div>

                    <button class="btn btn-danger btn-lg w-100" id="submitOrderBtn" onclick="submitOrder()">
                        提交订单
                    </button>

                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/cart/cart.jsp" class="text-muted text-decoration-none">
                            <i class="bi bi-arrow-left"></i> 返回购物车
                        </a>
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
        var cartIds = [];
        var selectedAddressId = null;
        var cartItems = [];

        $(document).ready(function() {
            // 检查登录状态
            checkLoginStatus();

            // 获取购物车ID
            var cartIdsParam = getUrlParam('cartIds');
            if (!cartIdsParam) {
                alert('请选择商品');
                location.href = '${pageContext.request.contextPath}/cart/cart.jsp';
                return;
            }
            cartIds = cartIdsParam.split(',');

            // 设置最小配送日期为明天
            var tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            var minDate = tomorrow.toISOString().split('T')[0];
            $('#deliveryDate').attr('min', minDate).val(minDate);

            // 加载地址
            loadAddresses();

            // 加载购物车商品
            loadCartItems();
        });

        function loadAddresses() {
            $.get('${pageContext.request.contextPath}/api/user/address', function(res) {
                if (res.code === 200 && res.data && res.data.length > 0) {
                    renderAddresses(res.data);
                    // 默认选中默认地址
                    var defaultAddr = res.data.find(function(addr) { return addr.isDefault === 1; });
                    if (defaultAddr) {
                        selectedAddressId = defaultAddr.id;
                    } else {
                        selectedAddressId = res.data[0].id;
                    }
                    updateAddressSelection();
                } else {
                    $('#addressList').html('<p class="text-muted mb-0">暂无收货地址，请新增</p>');
                }
            });
        }

        function renderAddresses(addresses) {
            var html = '<div class="list-group">';
            addresses.forEach(function(addr) {
                html += '<div class="list-group-item list-group-item-action address-item" data-id="' + addr.id + '" onclick="selectAddress(' + addr.id + ')">';
                html += '  <div class="d-flex justify-content-between align-items-center">';
                html += '    <div>';
                html += '      <h6 class="mb-1">' + esc(addr.receiverName) + ' ' + esc(addr.receiverPhone) + '</h6>';
                html += '      <p class="mb-0 text-muted">' + esc('' + addr.province + addr.city + addr.district + addr.detailAddress) + '</p>';
                html += '    </div>';
                if (addr.isDefault === 1) {
                    html += '    <span class="badge bg-danger">默认</span>';
                }
                html += '  </div>';
                html += '</div>';
            });
            html += '</div>';
            $('#addressList').html(html);
        }

        function selectAddress(id) {
            selectedAddressId = id;
            updateAddressSelection();
        }

        function updateAddressSelection() {
            $('.address-item').removeClass('active');
            $('.address-item[data-id="' + selectedAddressId + '"]').addClass('active');
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

        function loadCartItems() {
            $.get('${pageContext.request.contextPath}/api/cart/list', function(res) {
                if (res.code === 200 && res.data) {
                    // 过滤选中的商品
                    cartItems = res.data.filter(function(item) {
                        return cartIds.indexOf(item.id.toString()) !== -1;
                    });
                    renderOrderItems(cartItems);
                    updateTotal();
                }
            });
        }

        function renderOrderItems(items) {
            var html = '';
            items.forEach(function(item) {
                var price = item.spec && item.spec.price ? item.spec.price : (item.product ? item.product.price : 0);
                var totalPrice = price * item.quantity;
                var specText = item.spec ? (item.spec.specName + ': ' + item.spec.specValue) : '';

                html += '<tr>';
                html += '  <td>';
                html += '    <div class="d-flex align-items-center">';
                html += '      <img src="' + esc(productImg(item.product ? item.product.image : null)) + '" class="rounded me-3" style="width: 60px; height: 60px; object-fit: cover;" onerror="this.onerror=null;this.src=defaultProductImg">';
                html += '      <div>';
                html += '        <h6 class="mb-0">' + esc(item.product ? item.product.name : '') + '</h6>';
                if (specText) {
                    html += '        <small class="text-muted">' + esc(specText) + '</small>';
                }
                html += '      </div>';
                html += '    </div>';
                html += '  </td>';
                html += '  <td class="align-middle">¥' + price.toFixed(2) + '</td>';
                html += '  <td class="align-middle">x' + item.quantity + '</td>';
                html += '  <td class="align-middle text-danger fw-bold">¥' + totalPrice.toFixed(2) + '</td>';
                html += '</tr>';
            });

            $('#orderItems').html(html);
        }

        function updateTotal() {
            var total = 0;
            cartItems.forEach(function(item) {
                var price = item.spec && item.spec.price ? item.spec.price : (item.product ? item.product.price : 0);
                total += price * item.quantity;
            });

            $('#totalAmount').text('¥' + total.toFixed(2));
            $('#payAmount').text('¥' + total.toFixed(2));
        }

        function submitOrder() {
            if (!selectedAddressId) {
                alert('请选择收货地址');
                return;
            }

            var deliveryDate = $('#deliveryDate').val();
            var deliveryTime = $('#deliveryTime').val();
            if (!deliveryDate) {
                alert('请选择配送日期');
                return;
            }

            var delivery = deliveryDate + ' ' + deliveryTime;
            var remark = $('#remark').val().trim();

            // 禁用按钮
            var btn = $('#submitOrderBtn');
            btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 提交中...');

            $.post('${pageContext.request.contextPath}/api/order/create', {
                cartIds: cartIds.join(','),
                addressId: selectedAddressId,
                deliveryTime: delivery,
                remark: remark
            }, function(res) {
                if (res.code === 200) {
                    showToast('下单成功');
                    // 跳转到订单详情页
                    location.href = '${pageContext.request.contextPath}/order/detail.jsp?id=' + res.data.id;
                } else {
                    alert(res.msg || '下单失败');
                    btn.prop('disabled', false).html('提交订单');
                }
            }).fail(function() {
                alert('网络错误，请稍后重试');
                btn.prop('disabled', false).html('提交订单');
            });
        }
    </script>
</body>
</html>
