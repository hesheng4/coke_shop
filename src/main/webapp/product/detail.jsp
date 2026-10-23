<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品详情 - 蛋糕商城</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold text-danger" href="${pageContext.request.contextPath}/"><i class="bi bi-cake2"></i> 蛋糕商城</a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">首页</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/product/list.jsp">全部商品</a></li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart/cart.jsp"><i class="bi bi-cart3"></i> 购物车 <span class="badge bg-danger rounded-pill" id="cartCount">0</span></a></li>
                    <li class="nav-item" id="userMenu" style="display:none;">
                        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown"><i class="bi bi-person-circle"></i> <span id="username"></span></a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile.jsp">个人中心</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/order/list.jsp">我的订单</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#" onclick="logout()">退出登录</a></li>
                        </ul>
                    </li>
                    <li class="nav-item" id="loginBtn"><a class="nav-link" href="${pageContext.request.contextPath}/user/login.jsp"><i class="bi bi-box-arrow-in-right"></i> 登录</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <main style="margin-top:70px;">
        <div class="container py-4" id="productDetail">
            <div class="text-center py-5"><div class="spinner-border text-danger" role="status"></div></div>
        </div>
    </main>

    <footer class="bg-dark text-white py-3 mt-4">
        <div class="container text-center"><p class="mb-0">&copy; 2024 蛋糕商城 All Rights Reserved</p></div>
    </footer>

    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script>
    var productId = getUrlParam('id');
    var product = null;
    var selectedSpec = null;

    $(function() {
        checkLoginStatus();
        $('#productDetail').on('click', '.spec-btn', function() {
            selectSpec(this, $(this).data('label'), $(this).data('price'), $(this).data('stock'));
        });
        if (!productId) {
            $('#productDetail').html('<div class="text-center py-5 text-muted">商品不存在</div>');
            return;
        }
        loadDetail();
    });

    function loadDetail() {
        $.get(basePath + '/api/product/detail', {id: productId}, function(res) {
            if (res.code === 200 && res.data) {
                product = res.data;
                render();
            } else {
                $('#productDetail').html('<div class="text-center py-5 text-muted">商品不存在</div>');
            }
        }).fail(function() {
            $('#productDetail').html('<div class="text-center py-5 text-muted">加载失败</div>');
        });
    }

    function render() {
        var p = product;
        document.title = p.name + ' - 蛋糕商城';

        // 默认选中第一个规格
        if (p.specs && p.specs.length > 0) {
            selectedSpec = p.specs[0];
        }

        var price = selectedSpec ? selectedSpec.price : p.price;

        var html = '';
        html += '<nav class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">首页</a></li><li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/product/list.jsp">全部商品</a></li><li class="breadcrumb-item active">' + esc(p.name) + '</li></ol></nav>';
        html += '<div class="row">';
        html += '  <div class="col-md-5 mb-4">';
        html += '    <img src="' + esc(productImg(p.image)) + '" alt="' + esc(p.name) + '" class="w-100 rounded" style="height:350px;object-fit:cover;" onerror="this.onerror=null;this.src=defaultProductImg">';
        html += '  </div>';
        html += '  <div class="col-md-7">';
        html += '    <h2>' + esc(p.name) + '</h2>';
        html += '    <p class="text-muted">' + esc(p.description || '') + '</p>';
        html += '    <div class="bg-light p-3 rounded mb-3">';
        html += '      <span class="text-danger fs-3 fw-bold" id="currentPrice">&yen;' + price + '</span>';
        if (p.originalPrice && p.originalPrice > p.price) {
            html += '      <span class="text-muted text-decoration-line-through ms-3">&yen;' + p.originalPrice + '</span>';
        }
        html += '      <span class="text-muted ms-3" id="stockInfo">库存: ' + p.stock + ' 件</span>';
        html += '    </div>';

        // 规格选择
        if (p.specs && p.specs.length > 0) {
            html += '    <div class="mb-3" id="specSection">';
            html += '      <strong>规格选择</strong><br>';
            p.specs.forEach(function(s, i) {
                var specLabel = s.specName + ':' + s.specValue;
                html += '      <button class="btn btn-outline-danger btn-sm m-1 spec-btn' + (i===0?' active':'') + '" data-id="' + s.id + '" data-price="' + s.price + '" data-stock="' + s.stock + '" data-label="' + esc(specLabel) + '">' + esc(specLabel) + ' &yen;' + s.price + '</button>';
            });
            html += '    </div>';
        }

        html += '    <div class="mb-3">';
        html += '      <strong>数量</strong><br>';
        html += '      <button class="btn btn-outline-secondary btn-sm" onclick="changeQty(-1)">-</button>';
        html += '      <input type="text" class="form-control d-inline-block text-center mx-2" style="width:60px;" id="qty" value="1" readonly>';
        html += '      <button class="btn btn-outline-secondary btn-sm" onclick="changeQty(1)">+</button>';
        html += '    </div>';
        html += '    <div class="d-flex gap-2">';
        html += '      <button class="btn btn-danger btn-lg flex-fill" onclick="buyNow()"><i class="bi bi-lightning"></i> 立即购买</button>';
        html += '      <button class="btn btn-outline-danger btn-lg flex-fill" onclick="addToCart(' + p.id + ', selectedSpec?selectedSpec.id:null, parseInt($(\'#qty\').val()))"><i class="bi bi-cart-plus"></i> 加入购物车</button>';
        html += '    </div>';
        html += '    <div class="mt-3 border rounded p-2 text-muted small">';
        html += '      <span class="me-3"><i class="bi bi-check-circle text-success"></i> 正品保证</span>';
        html += '      <span class="me-3"><i class="bi bi-check-circle text-success"></i> 新鲜现做</span>';
        html += '      <span><i class="bi bi-check-circle text-success"></i> 冷链配送</span>';
        html += '    </div>';
        html += '  </div>';
        html += '</div>';

        $('#productDetail').html(html);
    }

    function selectSpec(el, name, price, stock) {
        $('.spec-btn').removeClass('active');
        $(el).addClass('active');
        selectedSpec = {id: $(el).data('id'), price: price, stock: stock};
        $('#currentPrice').text('¥' + price);
        $('#stockInfo').text('库存: ' + stock + ' 件');
    }

    function changeQty(delta) {
        var v = parseInt($('#qty').val()) + delta;
        if (v < 1) v = 1;
        if (v > 99) v = 99;
        $('#qty').val(v);
    }

    function buyNow() {
        var qty = parseInt($('#qty').val()) || 1;
        var specId = selectedSpec ? selectedSpec.id : null;
        addToCart(product.id, specId, qty);
        setTimeout(function() { window.location.href = '${pageContext.request.contextPath}/cart/cart.jsp'; }, 500);
    }
    </script>
</body>
</html>
