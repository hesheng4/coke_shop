<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品列表 - 蛋糕商城</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
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
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">首页</a></li>
                    <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/product/list.jsp">全部商品</a></li>
                </ul>
                <form class="d-flex me-3" action="${pageContext.request.contextPath}/product/list.jsp" method="get">
                    <div class="input-group">
                        <input type="text" class="form-control" name="keyword" placeholder="搜索蛋糕...">
                        <button class="btn btn-outline-danger" type="submit"><i class="bi bi-search"></i></button>
                    </div>
                </form>
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart/cart.jsp"><i class="bi bi-cart3"></i> 购物车 <span class="badge bg-danger rounded-pill" id="cartCount">0</span></a></li>
                    <li class="nav-item" id="userMenu" style="display:none;">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"><i class="bi bi-person-circle"></i> <span id="username"></span></a>
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
        <div class="container py-4">
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">首页</a></li>
                    <li class="breadcrumb-item active">全部商品</li>
                </ol>
            </nav>

            <div class="row">
                <div class="col-lg-3 mb-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white"><h5 class="mb-0">商品分类</h5></div>
                        <div class="list-group list-group-flush" id="categoryList">
                            <a href="${pageContext.request.contextPath}/product/list.jsp" class="list-group-item list-group-item-action active">全部分类</a>
                        </div>
                    </div>
                    <div class="card border-0 shadow-sm mt-3">
                        <div class="card-header bg-white"><h5 class="mb-0">排序方式</h5></div>
                        <div class="list-group list-group-flush">
                            <a href="?orderBy=" class="list-group-item list-group-item-action" id="sort_default">最新上架</a>
                            <a href="?orderBy=sales" class="list-group-item list-group-item-action" id="sort_sales">销量优先</a>
                            <a href="?orderBy=price_asc" class="list-group-item list-group-item-action" id="sort_price_asc">价格从低到高</a>
                            <a href="?orderBy=price_desc" class="list-group-item list-group-item-action" id="sort_price_desc">价格从高到低</a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-9">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="text-muted" id="productCount">加载中...</span>
                    </div>

                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="productList">
                        <div class="col-12 text-center"><div class="spinner-border text-danger" role="status"></div></div>
                    </div>

                    <div id="pagination" class="mt-4 text-center"></div>
                </div>
            </div>
        </div>
    </main>

    <footer class="bg-dark text-white py-3 mt-4">
        <div class="container text-center"><p class="mb-0">&copy; 2024 蛋糕商城 All Rights Reserved</p></div>
    </footer>

    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script>
    var currentPage = 1;
    var currentOrderBy = getUrlParam('orderBy') || '';
    var currentKeyword = getUrlParam('keyword') || '';
    var currentCategoryId = getUrlParam('categoryId') || '';

    $(function() {
        console.log('[product/list] ready');
        checkLoginStatus();
        highlightCurrentSort();
        loadCategories();
        loadProducts();
    });

    function highlightCurrentSort() {
        $('#sort_default, #sort_sales, #sort_price_asc, #sort_price_desc').removeClass('active');
        var id = currentOrderBy ? ('sort_' + currentOrderBy) : 'sort_default';
        $('#' + id).addClass('active');
    }

    function loadCategories() {
        // 使用已知分类
        var cats = [
            {id:1,name:'生日蛋糕'},{id:2,name:'婚礼蛋糕'},{id:3,name:'下午茶蛋糕'},
            {id:4,name:'节日蛋糕'},{id:5,name:'儿童蛋糕'}
        ];
        var html = '<a href="${pageContext.request.contextPath}/product/list.jsp" class="list-group-item list-group-item-action' + (!currentCategoryId?' active':'') + '">全部分类</a>';
        cats.forEach(function(c) {
            var active = currentCategoryId == c.id ? ' active' : '';
            html += '<a href="${pageContext.request.contextPath}/product/list.jsp?categoryId=' + c.id + '" class="list-group-item list-group-item-action' + active + '">' + c.name + '</a>';
        });
        $('#categoryList').html(html);
    }

    function loadProducts() {
        var params = {page:currentPage, pageSize:12};
        if (currentCategoryId) params.categoryId = currentCategoryId;
        if (currentKeyword) params.keyword = currentKeyword;
        if (currentOrderBy) params.orderBy = currentOrderBy;

        $.get(basePath + '/api/product/list', params, function(res) {
            if (res.code === 200 && res.data && res.data.list && res.data.list.length > 0) {
                renderProducts(res.data.list);
                $('#productCount').text('共 ' + res.data.page.totalCount + ' 件商品');
                $('#pagination').html(renderPagination(res.data.page));
            } else {
                var msg = (res && res.msg) ? res.msg : '暂无商品';
                $('#productList').html('<div class="col-12 text-center text-muted py-5">' + esc(msg) + '</div>');
                $('#pagination').html('');
            }
        }).fail(function() {
            $('#productList').html('<div class="col-12 text-center text-muted py-5">加载失败，请确认 Tomcat 已重启</div>');
        });
    }

    function goToPage(page) {
        if (page < 1) return;
        currentPage = page;
        loadProducts();
        $('html, body').animate({scrollTop: 200}, 300);
    }

    function renderProducts(products) {
        var html = '';
        products.forEach(function(p) {
            html += '<div class="col">';
            html += '  <div class="card h-100 product-card">';
            html += '    <a href="${pageContext.request.contextPath}/product/detail.jsp?id=' + p.id + '">';
            html += '      <img src="' + esc(productImg(p.image)) + '" alt="' + esc(p.name) + '" class="w-100" style="height:180px;object-fit:cover;" onerror="this.onerror=null;this.src=defaultProductImg">';
            html += '    </a>';
            html += '    <div class="card-body">';
            html += '      <h6 class="card-title"><a href="${pageContext.request.contextPath}/product/detail.jsp?id=' + p.id + '" class="text-decoration-none text-dark">' + esc(p.name) + '</a></h6>';
            html += '      <p class="card-text text-muted small">' + esc(p.description || '') + '</p>';
            html += '      <span class="text-danger fw-bold">&yen;' + p.price + '</span> ';
            if (p.originalPrice && p.originalPrice > p.price) {
                html += '      <small class="text-muted text-decoration-line-through">&yen;' + p.originalPrice + '</small>';
            }
            html += '      <button class="btn btn-danger btn-sm w-100 mt-2" onclick="addToCart(' + p.id + ')"><i class="bi bi-cart-plus"></i> 加入购物车</button>';
            html += '    </div>';
            html += '  </div>';
            html += '</div>';
        });
        $('#productList').html(html);
    }
    </script>
</body>
</html>
