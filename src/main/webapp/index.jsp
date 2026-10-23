<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>蛋糕商城 - 首页</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/">首页</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/product/list.jsp">全部商品</a>
                    </li>
                </ul>
                <form class="d-flex me-3" action="${pageContext.request.contextPath}/product/list.jsp" method="get">
                    <div class="input-group">
                        <input type="text" class="form-control" name="keyword" placeholder="搜索蛋糕...">
                        <button class="btn btn-outline-danger" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </form>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart/cart.jsp">
                            <i class="bi bi-cart3"></i> 购物车
                            <span class="badge bg-danger rounded-pill" id="cartCount">0</span>
                        </a>
                    </li>
                    <li class="nav-item" id="userMenu" style="display: none;">
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

    <!-- 轮播图 -->
    <div id="mainCarousel" class="carousel slide" data-bs-ride="carousel" style="margin-top: 56px;">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="2"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <div class="d-flex align-items-center justify-content-center" style="height:400px;background:linear-gradient(135deg,#ff9a9e,#fecfef);">
                    <div class="text-center text-white">
                        <h1 class="display-4 fw-bold">新鲜烘焙</h1>
                        <p class="lead">每一口都是幸福的味道</p>
                        <a href="${pageContext.request.contextPath}/product/list.jsp" class="btn btn-light btn-lg">立即选购</a>
                    </div>
                </div>
            </div>
            <div class="carousel-item">
                <div class="d-flex align-items-center justify-content-center" style="height:400px;background:linear-gradient(135deg,#a18cd1,#fbc2eb);">
                    <div class="text-center text-white">
                        <h1 class="display-4 fw-bold">生日蛋糕</h1>
                        <p class="lead">为特别的日子定制专属甜蜜</p>
                        <a href="${pageContext.request.contextPath}/product/list.jsp" class="btn btn-light btn-lg">查看详情</a>
                    </div>
                </div>
            </div>
            <div class="carousel-item">
                <div class="d-flex align-items-center justify-content-center" style="height:400px;background:linear-gradient(135deg,#ffecd2,#fcb69f);">
                    <div class="text-center text-white">
                        <h1 class="display-4 fw-bold">限时优惠</h1>
                        <p class="lead">新人注册立享8折优惠</p>
                        <a href="${pageContext.request.contextPath}/user/register.jsp" class="btn btn-light btn-lg">立即注册</a>
                    </div>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#mainCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>

    <!-- 热销商品 -->
    <section class="py-5">
        <div class="container">
            <div class="text-center mb-4">
                <h2 class="fw-bold">热销推荐</h2>
                <p class="text-muted">最受欢迎的美味蛋糕</p>
            </div>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4" id="hotProducts">
                <div class="col-12 text-center"><div class="spinner-border text-danger" role="status"></div></div>
            </div>
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/product/list.jsp" class="btn btn-outline-danger">查看更多</a>
            </div>
        </div>
    </section>

    <!-- 新品上架 -->
    <section class="py-5 bg-light">
        <div class="container">
            <div class="text-center mb-4">
                <h2 class="fw-bold">新品上架</h2>
                <p class="text-muted">最新出炉的美味蛋糕</p>
            </div>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4" id="newProducts">
                <div class="col-12 text-center"><div class="spinner-border text-danger" role="status"></div></div>
            </div>
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/product/list.jsp" class="btn btn-outline-danger">查看更多</a>
            </div>
        </div>
    </section>

    <!-- 页脚 -->
    <footer class="bg-dark text-white py-4 mt-4">
        <div class="container text-center">
            <p class="mb-0">&copy; 2024 蛋糕商城 All Rights Reserved</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script>
    // 页面加载完成后执行
    $(function() {
        console.log('[index] page ready');
        checkLoginStatus();
        loadProducts('/api/product/hot', '#hotProducts');
        loadProducts('/api/product/new', '#newProducts');
    });

    function loadProducts(url, container) {
        $.get(basePath + url, {limit: 8}, function(res) {
            if (res.code === 200 && res.data && res.data.length > 0) {
                var html = '';
                res.data.forEach(function(p) {
                    html += '<div class="col">';
                    html += '  <div class="card h-100 product-card">';
                    html += '    <a href="${pageContext.request.contextPath}/product/detail.jsp?id=' + p.id + '">';
                    html += '      <img src="' + esc(productImg(p.image)) + '" alt="' + esc(p.name) + '" class="w-100" style="height:180px;object-fit:cover;" onerror="this.onerror=null;this.src=defaultProductImg">';
                    html += '    </a>';
                    html += '    <div class="card-body">';
                    html += '      <h6 class="card-title">' + esc(p.name) + '</h6>';
                    html += '      <p class="card-text text-muted small">' + esc(p.description || '') + '</p>';
                    html += '      <div class="d-flex justify-content-between align-items-center">';
                    html += '        <span class="text-danger fw-bold">&yen;' + p.price + '</span>';
                    if (p.originalPrice && p.originalPrice > p.price) {
                        html += '      <small class="text-muted text-decoration-line-through">&yen;' + p.originalPrice + '</small>';
                    }
                    html += '      </div>';
                    html += '      <a href="${pageContext.request.contextPath}/product/detail.jsp?id=' + p.id + '" class="btn btn-outline-danger btn-sm w-100 mt-2">查看详情</a>';
                    html += '      <button class="btn btn-danger btn-sm w-100 mt-1" onclick="addToCart(' + p.id + ')"><i class="bi bi-cart-plus"></i> 加入购物车</button>';
                    html += '    </div>';
                    html += '  </div>';
                    html += '</div>';
                });
                $(container).html(html);
            } else {
                var msg = (res && res.msg) ? res.msg : '暂无商品';
                $(container).html('<div class="col-12 text-center text-muted">' + esc(msg) + '</div>');
            }
        }).fail(function(xhr) {
            $(container).html('<div class="col-12 text-center text-muted">加载失败，请确认 Tomcat 已重启</div>');
        });
    }
    </script>
</body>
</html>
