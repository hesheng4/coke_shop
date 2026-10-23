<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>后台管理 - 蛋糕商城</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body { background: #f4f6f9; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; }
        .sidebar {
            position: fixed; left: 0; top: 0; bottom: 0; width: 220px;
            background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%);
            z-index: 100; overflow-y: auto;
        }
        .sidebar .brand {
            padding: 24px 20px 16px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .sidebar .brand h4 { color: #fff; margin: 0; font-size: 20px; }
        .sidebar .brand p { color: rgba(255,255,255,0.5); margin: 4px 0 0; font-size: 12px; }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.7); padding: 13px 24px; display: flex; align-items: center;
            transition: all 0.2s; border-left: 3px solid transparent; font-size: 14px;
        }
        .sidebar .nav-link:hover { color: #fff; background: rgba(255,255,255,0.08); }
        .sidebar .nav-link.active {
            color: #fff; background: rgba(255,255,255,0.12); border-left-color: #3498db;
        }
        .sidebar .nav-link i { margin-right: 10px; font-size: 16px; width: 20px; text-align: center; }
        .main-wrapper { margin-left: 220px; min-height: 100vh; }
        .top-bar {
            background: #fff; padding: 12px 28px; display: flex; justify-content: space-between;
            align-items: center; border-bottom: 1px solid #e8ecf1; position: sticky; top: 0; z-index: 50;
        }
        .top-bar h5 { margin: 0; font-size: 16px; font-weight: 600; color: #2c3e50; }
        .content-area { padding: 24px 28px; }
        .stat-card {
            border: none; border-radius: 12px; padding: 20px 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06); transition: transform 0.2s, box-shadow 0.2s;
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 6px 20px rgba(0,0,0,0.1); }
        .stat-card .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
        .stat-card .stat-value { font-size: 28px; font-weight: 700; margin: 8px 0 2px; }
        .stat-card .stat-label { font-size: 13px; opacity: 0.8; }
        .data-table { background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); overflow: hidden; }
        .data-table .table-header { padding: 16px 20px; border-bottom: 1px solid #e8ecf1; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; }
        .data-table .table-header h6 { margin: 0; font-weight: 600; }
        .data-table table { margin: 0; }
        .data-table th { background: #f8f9fb; font-weight: 600; font-size: 13px; color: #666; border-bottom-width: 1px; }
        .data-table td { vertical-align: middle; font-size: 14px; }
        .data-table .table-footer { padding: 12px 20px; border-top: 1px solid #e8ecf1; display: flex; justify-content: space-between; align-items: center; }
        .badge-status { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
        .badge-status-0 { background: #fff3cd; color: #856404; }
        .badge-status-1 { background: #cce5ff; color: #004085; }
        .badge-status-2 { background: #d4edda; color: #155724; }
        .badge-status-3 { background: #d1ecf1; color: #0c5460; }
        .badge-status-4 { background: #f8d7da; color: #721c24; }
        .btn-action { padding: 3px 10px; font-size: 12px; border-radius: 6px; }
        .modal-content { border: none; border-radius: 12px; }
        .modal-header { border-bottom: 1px solid #e8ecf1; }
        .modal-footer { border-top: 1px solid #e8ecf1; }
        .product-thumb { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; }
        .search-bar { display: flex; gap: 8px; flex-wrap: wrap; }
        .search-bar .form-control, .search-bar .form-select { font-size: 13px; max-width: 180px; }
        .toast-container { z-index: 9999; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="brand">
            <h4><i class="bi bi-cake2"></i> 蛋糕商城</h4>
            <p>后台管理系统</p>
        </div>
        <nav class="nav flex-column" style="margin-top: 8px;">
            <a class="nav-link active" href="#" data-page="dashboard"><i class="bi bi-speedometer2"></i>控制台</a>
            <a class="nav-link" href="#" data-page="products"><i class="bi bi-box-seam"></i>商品管理</a>
            <a class="nav-link" href="#" data-page="categories"><i class="bi bi-tags"></i>分类管理</a>
            <a class="nav-link" href="#" data-page="orders"><i class="bi bi-receipt"></i>订单管理</a>
            <a class="nav-link" href="#" data-page="users"><i class="bi bi-people"></i>用户管理</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/" style="margin-top: 30px;"><i class="bi bi-arrow-left-circle"></i>返回前台</a>
        </nav>
    </div>

    <div class="main-wrapper">
        <div class="top-bar">
            <h5 id="pageTitle">控制台</h5>
            <div class="d-flex align-items-center">
                <span class="me-3 text-muted" style="font-size:14px;">欢迎，管理员</span>
                <button class="btn btn-outline-secondary btn-sm" onclick="adminLogout()"><i class="bi bi-box-arrow-right"></i> 退出</button>
            </div>
        </div>
        <div class="content-area" id="mainContent"></div>
    </div>

    <!-- 商品编辑模态框 -->
    <div class="modal fade" id="productModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="productModalTitle">添加商品</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="productForm">
                        <input type="hidden" id="pf_id">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">商品名称 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="pf_name" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">所属分类 <span class="text-danger">*</span></label>
                                <select class="form-select" id="pf_categoryId" required></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">售价 <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="pf_price" step="0.01" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">原价</label>
                                <input type="number" class="form-control" id="pf_originalPrice" step="0.01">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">库存</label>
                                <input type="number" class="form-control" id="pf_stock">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">商品图片URL</label>
                            <input type="text" class="form-control" id="pf_image" placeholder="例如：/static/images/cake1.jpg">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">简短描述</label>
                            <input type="text" class="form-control" id="pf_description" maxlength="500">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">详细说明</label>
                            <textarea class="form-control" id="pf_detail" rows="4"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" onclick="saveProduct()">保存</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 分类编辑模态框 -->
    <div class="modal fade" id="categoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="categoryModalTitle">添加分类</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="categoryForm">
                        <input type="hidden" id="cf_id">
                        <div class="mb-3">
                            <label class="form-label">分类名称 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="cf_name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">上级分类</label>
                            <select class="form-select" id="cf_parentId">
                                <option value="0">顶级分类</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">排序</label>
                            <input type="number" class="form-control" id="cf_sortOrder" value="0">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" onclick="saveCategory()">保存</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 订单详情模态框 -->
    <div class="modal fade" id="orderDetailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">订单详情</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="orderDetailBody"></div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
    <script>
    var CTX = '${pageContext.request.contextPath}';
    var API = CTX + '/api/admin';

    /** CSRF 令牌：会话签发，写请求经 X-CSRF-Token 头回传（同步获取，确保后续 ajax 可用） */
    var csrfToken = null;
    $.ajax({url: CTX + '/api/security/csrf', type: 'GET', dataType: 'json', async: false,
        success: function(r) { if (r && r.code === 200) csrfToken = r.data; }});

    function adminAjax(url, data, method, callback) {
        $.ajax({
            url: API + '/' + url,
            type: method || 'GET',
            data: data,
            dataType: 'json',
            beforeSend: function(xhr) {
                if (csrfToken) xhr.setRequestHeader('X-CSRF-Token', csrfToken);
            },
            success: function(res) {
                if (res.code === 401) { location.href = CTX + '/user/login.jsp'; return; }
                if (res.code === 403) { alert('\u65e0\u6743\u9650\u8bbf\u95ee'); return; }
                callback && callback(res);
            },
            error: function() { showToast('\u8bf7\u6c42\u5931\u8d25', 'error'); }
        });
    }
    function adminGet(url, data, cb) { adminAjax(url, data, 'GET', cb); }
    function adminPost(url, data, cb) { adminAjax(url, data, 'POST', cb); }

    function showToast(msg, type) {
        type = type || 'success';
        var cls = type === 'error' ? 'bg-danger' : 'bg-success';
        var h = '<div class="toast align-items-center text-white ' + cls + ' border-0" role="alert">' +
                '<div class="d-flex"><div class="toast-body">' + escHtml(msg) + '</div>' +
                '<button class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div></div>';
        var c = $('<div class="toast-container position-fixed top-0 end-0 p-3" style="z-index:9999"></div>');
        $('body').append(c); c.append(h);
        new bootstrap.Toast(c.find('.toast')[0], {delay: 2500}).show();
        setTimeout(function() { c.remove(); }, 3000);
    }

    function fmtDate(d) {
        if (!d) return '-';
        var t = new Date(d);
        return t.getFullYear() + '-' + String(t.getMonth()+1).padStart(2,'0') + '-' +
               String(t.getDate()).padStart(2,'0') + ' ' +
               String(t.getHours()).padStart(2,'0') + ':' + String(t.getMinutes()).padStart(2,'0');
    }
    function fmtMoney(n) { return n != null ? '\u00a5' + parseFloat(n).toFixed(2) : '-'; }

    var ORDER_STATUS = {0:'\u5f85\u4ed8\u6b3e', 1:'\u5f85\u53d1\u8d27', 2:'\u5f85\u6536\u8d27', 3:'\u5df2\u5b8c\u6210', 4:'\u5df2\u53d6\u6d88'};
    function orderStatusText(s) { return ORDER_STATUS[s] || '\u672a\u77e5'; }
    function orderStatusBadge(s) { return '<span class="badge-status badge-status-' + s + '">' + orderStatusText(s) + '</span>'; }

    function renderPagination(info) {
        if (!info || info.totalPages <= 1) return '';
        var h = '<nav><ul class="pagination pagination-sm justify-content-center mb-0">';
        if (info.hasPrev) h += '<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goPage(' + (info.page-1) + ')\">\u4e0a\u4e00\u9875</a></li>';
        else h += '<li class="page-item disabled"><span class="page-link">\u4e0a\u4e00\u9875</span></li>';
        for (var i = 1; i <= info.totalPages; i++) {
            if (i === info.page) h += '<li class="page-item active"><span class="page-link">' + i + '</span></li>';
            else if (Math.abs(i - info.page) <= 2 || i === 1 || i === info.totalPages)
                h += '<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goPage(' + i + ')">' + i + '</a></li>';
            else if (i === 2 || i === info.totalPages - 1) h += '<li class="page-item disabled"><span class="page-link">...</span></li>';
        }
        if (info.hasNext) h += '<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goPage(' + (info.page+1) + ')\">\u4e0b\u4e00\u9875</a></li>';
        else h += '<li class="page-item disabled"><span class="page-link">\u4e0b\u4e00\u9875</span></li>';
        h += '</ul></nav>';
        return h;
    }
    var _pageCb = null;
    function goPage(p) { if (_pageCb) _pageCb(p); }

    function adminLogout() {
        $.post(CTX + '/api/user/logout', function() { location.href = CTX + '/user/login.jsp'; });
    }
    function escHtml(s) {
        if (!s) return '';
        return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    // Page routing
    $(function() {
        $('.sidebar .nav-link[data-page]').click(function(e) {
            e.preventDefault();
            var page = $(this).data('page');
            if (!page) return;
            $('.sidebar .nav-link').removeClass('active');
            $(this).addClass('active');
            loadPage(page);
        });
        loadPage('dashboard');
    });

    function loadPage(page) {
        switch(page) {
            case 'dashboard': loadDashboard(); break;
            case 'products': loadProducts(); break;
            case 'categories': loadCategories(); break;
            case 'orders': loadOrders(); break;
            case 'users': loadUsers(); break;
        }
    }

    // ====== Dashboard ======
    function loadDashboard() {
        $('#pageTitle').text('\u63a7\u5236\u53f0');
        var html = '<div class="row">';
        html += '<div class="col-xl-3 col-md-6 mb-4"><div class="stat-card bg-white"><div class="d-flex align-items-center">';
        html += '<div class="stat-icon bg-primary bg-opacity-10 text-primary"><i class="bi bi-people-fill"></i></div>';
        html += '<div class="ms-3"><div class="stat-label text-muted">\u7528\u6237\u603b\u6570</div><div class="stat-value text-dark" id="s_userCount">-</div></div>';
        html += '</div></div></div>';
        html += '<div class="col-xl-3 col-md-6 mb-4"><div class="stat-card bg-white"><div class="d-flex align-items-center">';
        html += '<div class="stat-icon bg-success bg-opacity-10 text-success"><i class="bi bi-box-seam-fill"></i></div>';
        html += '<div class="ms-3"><div class="stat-label text-muted">\u5546\u54c1\u603b\u6570</div><div class="stat-value text-dark" id="s_productCount">-</div></div>';
        html += '</div></div></div>';
        html += '<div class="col-xl-3 col-md-6 mb-4"><div class="stat-card bg-white"><div class="d-flex align-items-center">';
        html += '<div class="stat-icon bg-warning bg-opacity-10 text-warning"><i class="bi bi-receipt"></i></div>';
        html += '<div class="ms-3"><div class="stat-label text-muted">\u8ba2\u5355\u603b\u6570</div><div class="stat-value text-dark" id="s_orderCount">-</div></div>';
        html += '</div></div></div>';
        html += '<div class="col-xl-3 col-md-6 mb-4"><div class="stat-card bg-white"><div class="d-flex align-items-center">';
        html += '<div class="stat-icon bg-info bg-opacity-10 text-info"><i class="bi bi-cash-stack"></i></div>';
        html += '<div class="ms-3"><div class="stat-label text-muted">\u4eca\u65e5\u9500\u552e\u989d</div><div class="stat-value text-dark" id="s_todaySales">-</div></div>';
        html += '</div></div></div>';
        html += '</div>';
        html += '<div class="row"><div class="col-md-6 mb-4">';
        html += '<div class="data-table"><div class="table-header"><h6>\u4eca\u65e5\u6982\u51b5</h6></div>';
        html += '<div class="p-3" id="todayInfo">\u52a0\u8f7d\u4e2d...</div></div></div>';
        html += '<div class="col-md-6 mb-4"><div class="data-table"><div class="table-header"><h6>\u5feb\u6377\u64cd\u4f5c</h6></div>';
        html += '<div class="p-3">';
        html += '<a href="javascript:void(0)" onclick="loadPage(\'products\')" class="btn btn-outline-primary me-2 mb-2"><i class="bi bi-plus-circle"></i> \u6dfb\u52a0\u5546\u54c1</a>';
        html += '<a href="javascript:void(0)" onclick="loadPage(\'orders\')" class="btn btn-outline-success me-2 mb-2"><i class="bi bi-truck"></i> \u8ba2\u5355\u53d1\u8d27</a>';
        html += '<a href="javascript:void(0)" onclick="loadPage(\'categories\')" class="btn btn-outline-info me-2 mb-2"><i class="bi bi-tags"></i> \u5206\u7c7b\u7ba1\u7406</a>';
        html += '<a href="javascript:void(0)" onclick="loadPage(\'users\')" class="btn btn-outline-warning mb-2"><i class="bi bi-person-gear"></i> \u7528\u6237\u7ba1\u7406</a>';
        html += '</div></div></div></div>';
        $('#mainContent').html(html);
        adminGet('index', null, function(res) {
            if (res.code === 200 && res.data) {
                var d = res.data;
                $('#s_userCount').text(d.userCount || 0);
                $('#s_productCount').text(d.productCount || 0);
                $('#s_orderCount').text(d.orderCount || 0);
                $('#s_todaySales').text(fmtMoney(d.todaySales));
                $('#todayInfo').html(
                    '<p class="mb-2">\u4eca\u65e5\u8ba2\u5355\uff1a<strong>' + (d.todayOrderCount || 0) + '</strong> \u7b14</p>' +
                    '<p class="mb-2">\u4eca\u65e5\u9500\u552e\u989d\uff1a<strong class="text-danger">' + fmtMoney(d.todaySales) + '</strong></p>' +
                    '<p class="mb-0">\u603b\u5546\u54c1\u6570\uff1a<strong>' + (d.productCount || 0) + '</strong> \u4ef6</p>'
                );
            }
        });
    }

    // ====== Products ======
    var _productPage = 1;
    function loadProducts() {
        $('#pageTitle').text('\u5546\u54c1\u7ba1\u7406');
        var html = '<div class="data-table">';
        html += '<div class="table-header"><h6>\u5546\u54c1\u5217\u8868</h6>';
        html += '<div class="search-bar">';
        html += '<select class="form-select form-select-sm" id="p_categoryFilter"><option value="">\u5168\u90e8\u5206\u7c7b</option></select>';
        html += '<input type="text" class="form-control form-control-sm" id="p_keyword" placeholder="\u641c\u7d22\u5546\u54c1\u540d\u79f0">';
        html += '<button class="btn btn-primary btn-sm" onclick="searchProducts()"><i class="bi bi-search"></i></button>';
        html += '<button class="btn btn-success btn-sm" onclick="openProductModal()"><i class="bi bi-plus-lg"></i> \u6dfb\u52a0\u5546\u54c1</button>';
        html += '</div></div>';
        html += '<div class="table-responsive"><table class="table table-hover mb-0">';
        html += '<thead><tr><th style="width:60px">ID</th><th style="width:60px">\u56fe\u7247</th><th>\u5546\u54c1\u540d\u79f0</th><th>\u5206\u7c7b</th><th>\u4ef7\u683c</th><th>\u5e93\u5b58</th><th>\u9500\u91cf</th><th>\u72b6\u6001</th><th style="width:160px">\u64cd\u4f5c</th></tr></thead>';
        html += '<tbody id="productTableBody"><tr><td colspan="9" class="text-center p-4">\u52a0\u8f7d\u4e2d...</td></tr></tbody>';
        html += '</table></div>';
        html += '<div class="table-footer"><span class="text-muted small" id="productCountInfo"></span><div id="productPagination"></div></div>';
        html += '</div>';
        $('#mainContent').html(html);
        _productPage = 1;
        adminGet('category/list', null, function(res) {
            if (res.code === 200 && res.data) {
                var opts = '<option value="">\u5168\u90e8\u5206\u7c7b</option>';
                $.each(res.data, function(i, c) {
                    opts += '<option value="' + c.id + '">' + escHtml(c.name) + '</option>';
                    if (c.children && c.children.length) {
                        $.each(c.children, function(j, sc) {
                            opts += '<option value="' + sc.id + '">  \u2514 ' + escHtml(sc.name) + '</option>';
                        });
                    }
                });
                $('#p_categoryFilter').html(opts);
            }
        });
        loadProductList(1);
    }

    function loadProductList(page) {
        _productPage = page;
        var data = { page: page, pageSize: 10 };
        var catId = $('#p_categoryFilter').val();
        var kw = $('#p_keyword').val();
        if (catId) data.categoryId = catId;
        if (kw) data.keyword = kw;
        adminGet('product/list', data, function(res) {
            if (res.code === 200 && res.data) {
                var list = res.data.list || [];
                var pageInfo = res.data.page;
                var h = '';
                if (list.length === 0) {
                    h = '<tr><td colspan="9" class="text-center text-muted p-4">\u6682\u65e0\u5546\u54c1\u6570\u636e</td></tr>';
                } else {
                    $.each(list, function(i, p) {
                        h += '<tr>';
                        h += '<td>' + p.id + '</td>';
                        h += '<td>' + (p.image ? '<img src="' + escHtml(CTX + p.image) + '" class="product-thumb" onerror="this.src=\'' + CTX + '/static/images/default-cake.svg\'">' : '-') + '</td>';
                        h += '<td><strong>' + escHtml(p.name) + '</strong></td>';
                        h += '<td>' + escHtml(p.categoryName || '-') + '</td>';
                        h += '<td>' + fmtMoney(p.price) + (p.originalPrice ? '<br><small class="text-muted text-decoration-line-through">' + fmtMoney(p.originalPrice) + '</small>' : '') + '</td>';
                        h += '<td>' + (p.stock || 0) + '</td>';
                        h += '<td>' + (p.sales || 0) + '</td>';
                        h += '<td>' + (p.status === 1 ? '<span class="badge bg-success">\u4e0a\u67b6</span>' : '<span class="badge bg-secondary">\u4e0b\u67b6</span>') + '</td>';
                        h += '<td>';
                        h += '<button class="btn btn-outline-primary btn-action me-1" onclick="editProduct(' + p.id + ')"><i class="bi bi-pencil"></i></button>';
                        h += '<button class="btn btn-outline-' + (p.status === 1 ? 'warning' : 'success') + ' btn-action me-1" onclick="toggleProductStatus(' + p.id + ',' + (p.status === 1 ? 0 : 1) + ')" title="' + (p.status === 1 ? '\u4e0b\u67b6' : '\u4e0a\u67b6') + '"><i class="bi bi-' + (p.status === 1 ? 'eye-slash' : 'eye') + '"></i></button>';
                        h += '<button class="btn btn-outline-danger btn-action" onclick="deleteProduct(' + p.id + ')" title="\u5220\u9664"><i class="bi bi-trash"></i></button>';
                        h += '</td></tr>';
                    });
                }
                $('#productTableBody').html(h);
                $('#productCountInfo').text('\u5171 ' + pageInfo.totalCount + ' \u4ef6\u5546\u54c1');
                _pageCb = loadProductList;
                $('#productPagination').html(renderPagination(pageInfo));
            }
        });
    }

    function searchProducts() { loadProductList(1); }

    function openProductModal(id) {
        $('#pf_id').val('');
        $('#pf_name, #pf_price, #pf_originalPrice, #pf_stock, #pf_image, #pf_description, #pf_detail').val('');
        $('#pf_categoryId').val('');
        $('#productModalTitle').text(id ? '\u7f16\u8f91\u5546\u54c1' : '\u6dfb\u52a0\u5546\u54c1');
        adminGet('category/list', null, function(res) {
            if (res.code === 200 && res.data) {
                var opts = '';
                $.each(res.data, function(i, c) {
                    opts += '<option value="' + c.id + '">' + escHtml(c.name) + '</option>';
                    if (c.children && c.children.length) {
                        $.each(c.children, function(j, sc) {
                            opts += '<option value="' + sc.id + '">  \u2514 ' + escHtml(sc.name) + '</option>';
                        });
                    }
                });
                $('#pf_categoryId').html(opts);
            }
        });
        if (id) {
            adminGet('product/detail', { id: id }, function(res) {
                if (res.code === 200 && res.data) {
                    var p = res.data;
                    $('#pf_id').val(p.id);
                    $('#pf_name').val(p.name);
                    $('#pf_categoryId').val(p.categoryId);
                    $('#pf_price').val(p.price);
                    $('#pf_originalPrice').val(p.originalPrice || '');
                    $('#pf_stock').val(p.stock || '');
                    $('#pf_image').val(p.image || '');
                    $('#pf_description').val(p.description || '');
                    $('#pf_detail').val(p.detail || '');
                }
            });
        }
        new bootstrap.Modal($('#productModal')[0]).show();
    }

    function editProduct(id) { openProductModal(id); }

    function saveProduct() {
        var data = {
            name: $('#pf_name').val().trim(),
            categoryId: $('#pf_categoryId').val(),
            price: $('#pf_price').val(),
            originalPrice: $('#pf_originalPrice').val(),
            stock: $('#pf_stock').val(),
            image: $('#pf_image').val(),
            description: $('#pf_description').val(),
            detail: $('#pf_detail').val()
        };
        if (!data.name || !data.categoryId || !data.price) {
            showToast('\u8bf7\u586b\u5199\u5fc5\u586b\u9879', 'error'); return;
        }
        var id = $('#pf_id').val();
        var url = id ? 'product/update' : 'product/add';
        if (id) data.id = id;
        adminPost(url, data, function(res) {
            if (res.code === 200) {
                showToast(id ? '\u66f4\u65b0\u6210\u529f' : '\u6dfb\u52a0\u6210\u529f');
                bootstrap.Modal.getInstance($('#productModal')[0]).hide();
                loadProductList(_productPage);
            } else {
                showToast(res.msg || '\u64cd\u4f5c\u5931\u8d25', 'error');
            }
        });
    }

    function toggleProductStatus(id, status) {
        var act = status === 1 ? '\u4e0a\u67b6' : '\u4e0b\u67b6';
        if (!confirm('\u786e\u5b9a\u8981' + act + '\u8be5\u5546\u54c1\u5417\uff1f')) return;
        adminPost('product/status', { productId: id, status: status }, function(res) {
            if (res.code === 200) { showToast(act + '\u6210\u529f'); loadProductList(_productPage); }
            else showToast(res.msg || act + '\u5931\u8d25', 'error');
        });
    }

    function deleteProduct(id) {
        if (!confirm('\u786e\u5b9a\u8981\u5220\u9664\u8be5\u5546\u54c1\u5417\uff1f\u6b64\u64cd\u4f5c\u4e0d\u53ef\u6062\u590d\uff01')) return;
        adminPost('product/delete', { productId: id }, function(res) {
            if (res.code === 200) { showToast('\u5220\u9664\u6210\u529f'); loadProductList(_productPage); }
            else showToast(res.msg || '\u5220\u9664\u5931\u8d25', 'error');
        });
    }

    // ====== Categories ======
    function loadCategories() {
        $('#pageTitle').text('\u5206\u7c7b\u7ba1\u7406');
        var html = '<div class="data-table">';
        html += '<div class="table-header"><h6>\u5206\u7c7b\u5217\u8868</h6>';
        html += '<button class="btn btn-success btn-sm" onclick="openCategoryModal()"><i class="bi bi-plus-lg"></i> \u6dfb\u52a0\u5206\u7c7b</button></div>';
        html += '<div class="table-responsive"><table class="table table-hover mb-0">';
        html += '<thead><tr><th style="width:60px">ID</th><th>\u5206\u7c7b\u540d\u79f0</th><th>\u4e0a\u7ea7\u5206\u7c7b</th><th>\u6392\u5e8f</th><th>\u72b6\u6001</th><th style="width:180px">\u64cd\u4f5c</th></tr></thead>';
        html += '<tbody id="categoryTableBody"><tr><td colspan="6" class="text-center p-4">\u52a0\u8f7d\u4e2d...</td></tr></tbody>';
        html += '</table></div></div>';
        $('#mainContent').html(html);
        loadCategoryList();
    }

    function loadCategoryList() {
        adminGet('category/tree', null, function(res) {
            if (res.code === 200 && res.data) {
                var h = '';
                if (res.data.length === 0) {
                    h = '<tr><td colspan="6" class="text-center text-muted p-4">\u6682\u65e0\u5206\u7c7b\u6570\u636e</td></tr>';
                } else {
                    $.each(res.data, function(i, c) {
                        h += renderCategoryRow(c, true);
                        if (c.children && c.children.length) {
                            $.each(c.children, function(j, sc) { h += renderCategoryRow(sc, false); });
                        }
                    });
                }
                $('#categoryTableBody').html(h);
            }
        });
    }

    function renderCategoryRow(c, isParent) {
        var prefix = isParent ? '' : '<i class="bi bi-arrow-return-right me-1 text-muted"></i>';
        var statusBadge = c.status === 1 ? '<span class="badge bg-success">\u542f\u7528</span>' : '<span class="badge bg-secondary">\u7981\u7528</span>';
        var h = '<tr><td>' + c.id + '</td>';
        h += '<td>' + prefix + escHtml(c.name) + '</td>';
        h += '<td>' + (c.parentId && c.parentId > 0 ? escHtml(c.parentName || '\u4e0a\u7ea7\u5206\u7c7b') : '<span class="text-muted">\u9876\u7ea7\u5206\u7c7b</span>') + '</td>';
        h += '<td>' + (c.sortOrder || 0) + '</td><td>' + statusBadge + '</td>';
        h += '<td>';
        h += '<button class="btn btn-outline-primary btn-action me-1" onclick="editCategory(' + c.id + ')"><i class="bi bi-pencil"></i></button>';
        h += '<button class="btn btn-outline-' + (c.status === 1 ? 'warning' : 'success') + ' btn-action me-1" onclick="toggleCategoryStatus(' + c.id + ',' + (c.status === 1 ? 0 : 1) + ')" title="' + (c.status === 1 ? '\u7981\u7528' : '\u542f\u7528') + '"><i class="bi bi-' + (c.status === 1 ? 'eye-slash' : 'eye') + '"></i></button>';
        h += '<button class="btn btn-outline-danger btn-action" onclick="deleteCategory(' + c.id + ')" title="\u5220\u9664"><i class="bi bi-trash"></i></button>';
        h += '</td></tr>';
        return h;
    }

    function openCategoryModal(id) {
        $('#cf_id').val(''); $('#cf_name').val(''); $('#cf_parentId').val('0'); $('#cf_sortOrder').val('0');
        $('#categoryModalTitle').text(id ? '\u7f16\u8f91\u5206\u7c7b' : '\u6dfb\u52a0\u5206\u7c7b');
        adminGet('category/list', null, function(res) {
            if (res.code === 200 && res.data) {
                var opts = '<option value="0">\u9876\u7ea7\u5206\u7c7b</option>';
                $.each(res.data, function(i, c) {
                    if (!c.parentId || c.parentId === 0) opts += '<option value="' + c.id + '">' + escHtml(c.name) + '</option>';
                });
                $('#cf_parentId').html(opts);
            }
        });
        if (id) {
            adminGet('category/list', null, function(res) {
                if (res.code === 200 && res.data) {
                    var cat = null;
                    $.each(res.data, function(i, c) { if (c.id === id) { cat = c; return false; } });
                    if (cat) {
                        $('#cf_id').val(cat.id); $('#cf_name').val(cat.name);
                        $('#cf_parentId').val(cat.parentId || 0); $('#cf_sortOrder').val(cat.sortOrder || 0);
                    }
                }
            });
        }
        new bootstrap.Modal($('#categoryModal')[0]).show();
    }

    function editCategory(id) { openCategoryModal(id); }

    function saveCategory() {
        var data = { name: $('#cf_name').val().trim(), parentId: $('#cf_parentId').val(), sortOrder: $('#cf_sortOrder').val() };
        if (!data.name) { showToast('\u8bf7\u8f93\u5165\u5206\u7c7b\u540d\u79f0', 'error'); return; }
        var id = $('#cf_id').val();
        var url = id ? 'category/update' : 'category/add';
        if (id) data.id = id;
        adminPost(url, data, function(res) {
            if (res.code === 200) {
                showToast(id ? '\u66f4\u65b0\u6210\u529f' : '\u6dfb\u52a0\u6210\u529f');
                bootstrap.Modal.getInstance($('#categoryModal')[0]).hide();
                loadCategoryList();
            } else { showToast(res.msg || '\u64cd\u4f5c\u5931\u8d25', 'error'); }
        });
    }

    function toggleCategoryStatus(id, status) {
        var act = status === 1 ? '\u542f\u7528' : '\u7981\u7528';
        if (!confirm('\u786e\u5b9a\u8981' + act + '\u8be5\u5206\u7c7b\u5417\uff1f')) return;
        adminPost('category/status', { id: id, status: status }, function(res) {
            if (res.code === 200) { showToast(act + '\u6210\u529f'); loadCategoryList(); }
            else showToast(res.msg || act + '\u5931\u8d25', 'error');
        });
    }

    function deleteCategory(id) {
        if (!confirm('\u786e\u5b9a\u8981\u5220\u9664\u8be5\u5206\u7c7b\u5417\uff1f')) return;
        adminPost('category/delete', { id: id }, function(res) {
            if (res.code === 200) { showToast('\u5220\u9664\u6210\u529f'); loadCategoryList(); }
            else showToast(res.msg || '\u5220\u9664\u5931\u8d25', 'error');
        });
    }

    // ====== Orders ======
    var _orderPage = 1;
    function loadOrders() {
        $('#pageTitle').text('\u8ba2\u5355\u7ba1\u7406');
        var html = '<div class="data-table">';
        html += '<div class="table-header"><h6>\u8ba2\u5355\u5217\u8868</h6>';
        html += '<div class="search-bar">';
        html += '<select class="form-select form-select-sm" id="o_statusFilter">';
        html += '<option value="">\u5168\u90e8\u72b6\u6001</option>';
        html += '<option value="0">\u5f85\u4ed8\u6b3e</option><option value="1">\u5f85\u53d1\u8d27</option>';
        html += '<option value="2">\u5f85\u6536\u8d27</option><option value="3">\u5df2\u5b8c\u6210</option>';
        html += '<option value="4">\u5df2\u53d6\u6d88</option>';
        html += '</select>';
        html += '<button class="btn btn-primary btn-sm" onclick="searchOrders()"><i class="bi bi-search"></i></button>';
        html += '</div></div>';
        html += '<div class="table-responsive"><table class="table table-hover mb-0">';
        html += '<thead><tr><th style="width:80px">\u8ba2\u5355\u53f7</th><th>\u7528\u6237ID</th><th>\u6536\u8d27\u4eba</th><th>\u91d1\u989d</th><th>\u72b6\u6001</th><th>\u4e0b\u5355\u65f6\u95f4</th><th style="width:140px">\u64cd\u4f5c</th></tr></thead>';
        html += '<tbody id="orderTableBody"><tr><td colspan="7" class="text-center p-4">\u52a0\u8f7d\u4e2d...</td></tr></tbody>';
        html += '</table></div>';
        html += '<div class="table-footer"><span class="text-muted small" id="orderCountInfo"></span><div id="orderPagination"></div></div>';
        html += '</div>';
        $('#mainContent').html(html);
        _orderPage = 1;
        loadOrderList(1);
    }

    function loadOrderList(page) {
        _orderPage = page;
        var data = { page: page, pageSize: 10 };
        var status = $('#o_statusFilter').val();
        if (status !== '') data.status = status;
        adminGet('order/list', data, function(res) {
            if (res.code === 200 && res.data) {
                var list = res.data.list || [];
                var pageInfo = res.data.page;
                var h = '';
                if (list.length === 0) {
                    h = '<tr><td colspan="7" class="text-center text-muted p-4">\u6682\u65e0\u8ba2\u5355\u6570\u636e</td></tr>';
                } else {
                    $.each(list, function(i, o) {
                        h += '<tr>';
                        h += '<td><small>' + escHtml(o.orderNo) + '</small></td>';
                        h += '<td>' + o.userId + '</td>';
                        h += '<td>' + escHtml(o.receiverName) + '<br><small class="text-muted">' + escHtml(o.receiverPhone) + '</small></td>';
                        h += '<td>' + fmtMoney(o.payAmount) + '</td>';
                        h += '<td>' + orderStatusBadge(o.status) + '</td>';
                        h += '<td><small>' + fmtDate(o.createTime) + '</small></td>';
                        h += '<td>';
                        h += '<button class="btn btn-outline-info btn-action me-1" onclick="viewOrder(' + o.id + ')" title="\u8be6\u60c5"><i class="bi bi-eye"></i></button>';
                        if (o.status === 1) {
                            h += '<button class="btn btn-outline-success btn-action me-1" onclick="shipOrder(' + o.id + ')" title="\u53d1\u8d27"><i class="bi bi-truck"></i></button>';
                        }
                        if (o.status === 0 || o.status === 1) {
                            h += '<button class="btn btn-outline-danger btn-action" onclick="cancelOrder(' + o.id + ')" title="\u53d6\u6d88"><i class="bi bi-x-circle"></i></button>';
                        }
                        h += '</td></tr>';
                    });
                }
                $('#orderTableBody').html(h);
                $('#orderCountInfo').text('\u5171 ' + pageInfo.totalCount + ' \u7b14\u8ba2\u5355');
                _pageCb = loadOrderList;
                $('#orderPagination').html(renderPagination(pageInfo));
            }
        });
    }

    function searchOrders() { loadOrderList(1); }

    function viewOrder(id) {
        adminGet('order/detail', { id: id }, function(res) {
            if (res.code === 200 && res.data) {
                var o = res.data;
                var h = '<div class="row mb-3">';
                h += '<div class="col-md-6"><p class="mb-1"><strong>\u8ba2\u5355\u53f7\uff1a</strong>' + escHtml(o.orderNo) + '</p>';
                h += '<p class="mb-1"><strong>\u72b6\u6001\uff1a</strong>' + orderStatusBadge(o.status) + '</p>';
                h += '<p class="mb-1"><strong>\u4e0b\u5355\u65f6\u95f4\uff1a</strong>' + fmtDate(o.createTime) + '</p></div>';
                h += '<div class="col-md-6"><p class="mb-1"><strong>\u6536\u8d27\u4eba\uff1a</strong>' + escHtml(o.receiverName) + '</p>';
                h += '<p class="mb-1"><strong>\u8054\u7cfb\u7535\u8bdd\uff1a</strong>' + escHtml(o.receiverPhone) + '</p>';
                h += '<p class="mb-0"><strong>\u6536\u8d27\u5730\u5740\uff1a</strong>' + escHtml(o.receiverAddress) + '</p></div></div>';
                h += '<h6 class="mb-2">\u5546\u54c1\u660e\u7ec6</h6>';
                h += '<table class="table table-sm table-bordered"><thead><tr><th>\u5546\u54c1</th><th>\u89c4\u683c</th><th>\u5355\u4ef7</th><th>\u6570\u91cf</th><th>\u5c0f\u8ba1</th></tr></thead><tbody>';
                if (o.items && o.items.length) {
                    $.each(o.items, function(i, item) {
                        h += '<tr><td>' + escHtml(item.productName) + '</td>';
                        h += '<td>' + escHtml(item.specName || '-') + '</td>';
                        h += '<td>' + fmtMoney(item.price) + '</td>';
                        h += '<td>' + item.quantity + '</td>';
                        h += '<td>' + fmtMoney(item.totalPrice) + '</td></tr>';
                    });
                }
                h += '</tbody></table>';
                h += '<div class="text-end"><strong>\u8ba2\u5355\u603b\u989d\uff1a</strong><span class="text-danger fs-5">' + fmtMoney(o.totalAmount) + '</span>';
                if (o.discountAmount > 0) h += ' <small class="text-muted">(\u4f18\u60e0\uff1a' + fmtMoney(o.discountAmount) + ')</small>';
                h += ' <strong>\u5b9e\u4ed8\uff1a</strong><span class="text-danger fs-5">' + fmtMoney(o.payAmount) + '</span></div>';
                if (o.remark) h += '<div class="mt-2"><strong>\u5907\u6ce8\uff1a</strong>' + escHtml(o.remark) + '</div>';
                $('#orderDetailBody').html(h);
                new bootstrap.Modal($('#orderDetailModal')[0]).show();
            }
        });
    }

    function shipOrder(id) {
        if (!confirm('\u786e\u5b9a\u8981\u53d1\u8d27\u5417\uff1f')) return;
        adminPost('order/ship', { orderId: id }, function(res) {
            if (res.code === 200) { showToast('\u53d1\u8d27\u6210\u529f'); loadOrderList(_orderPage); }
            else showToast(res.msg || '\u53d1\u8d27\u5931\u8d25', 'error');
        });
    }

    function cancelOrder(id) {
        if (!confirm('\u786e\u5b9a\u8981\u53d6\u6d88\u8be5\u8ba2\u5355\u5417\uff1f')) return;
        adminPost('order/cancel', { orderId: id }, function(res) {
            if (res.code === 200) { showToast('\u53d6\u6d88\u6210\u529f'); loadOrderList(_orderPage); }
            else showToast(res.msg || '\u53d6\u6d88\u5931\u8d25', 'error');
        });
    }

    // ====== Users ======
    var _userPage = 1;
    function loadUsers() {
        $('#pageTitle').text('\u7528\u6237\u7ba1\u7406');
        var html = '<div class="data-table">';
        html += '<div class="table-header"><h6>\u7528\u6237\u5217\u8868</h6></div>';
        html += '<div class="table-responsive"><table class="table table-hover mb-0">';
        html += '<thead><tr><th style="width:60px">ID</th><th>\u7528\u6237\u540d</th><th>\u90ae\u7bb1</th><th>\u624b\u673a\u53f7</th><th>\u89d2\u8272</th><th>\u72b6\u6001</th><th>\u6ce8\u518c\u65f6\u95f4</th><th style="width:100px">\u64cd\u4f5c</th></tr></thead>';
        html += '<tbody id="userTableBody"><tr><td colspan="8" class="text-center p-4">\u52a0\u8f7d\u4e2d...</td></tr></tbody>';
        html += '</table></div>';
        html += '<div class="table-footer"><span class="text-muted small" id="userCountInfo"></span><div id="userPagination"></div></div>';
        html += '</div>';
        $('#mainContent').html(html);
        _userPage = 1;
        loadUserList(1);
    }

    function loadUserList(page) {
        _userPage = page;
        adminGet('user/list', { page: page, pageSize: 10 }, function(res) {
            if (res.code === 200 && res.data) {
                var list = res.data.list || [];
                var pageInfo = res.data.page;
                var h = '';
                if (list.length === 0) {
                    h = '<tr><td colspan="8" class="text-center text-muted p-4">\u6682\u65e0\u7528\u6237\u6570\u636e</td></tr>';
                } else {
                    $.each(list, function(i, u) {
                        h += '<tr><td>' + u.id + '</td>';
                        h += '<td>' + escHtml(u.username) + '</td>';
                        h += '<td>' + escHtml(u.email || '-') + '</td>';
                        h += '<td>' + escHtml(u.phone || '-') + '</td>';
                        h += '<td>' + (u.role === 1 ? '<span class="badge bg-primary">\u7ba1\u7406\u5458</span>' : '<span class="badge bg-light text-dark">\u666e\u901a\u7528\u6237</span>') + '</td>';
                        h += '<td>' + (u.status === 1 ? '<span class="badge bg-success">\u6b63\u5e38</span>' : '<span class="badge bg-danger">\u7981\u7528</span>') + '</td>';
                        h += '<td><small>' + fmtDate(u.createTime) + '</small></td>';
                        h += '<td>';
                        if (u.username !== 'admin') {
                            h += '<button class="btn btn-outline-' + (u.status === 1 ? 'danger' : 'success') + ' btn-action" onclick="toggleUserStatus(' + u.id + ',' + (u.status === 1 ? 0 : 1) + ')">';
                            h += (u.status === 1 ? '\u7981\u7528' : '\u542f\u7528') + '</button>';
                        } else {
                            h += '<span class="text-muted small">\u8d85\u7ea7\u7ba1\u7406\u5458</span>';
                        }
                        h += '</td></tr>';
                    });
                }
                $('#userTableBody').html(h);
                $('#userCountInfo').text('\u5171 ' + pageInfo.totalCount + ' \u4f4d\u7528\u6237');
                _pageCb = loadUserList;
                $('#userPagination').html(renderPagination(pageInfo));
            }
        });
    }

    function toggleUserStatus(id, status) {
        var act = status === 0 ? '\u7981\u7528' : '\u542f\u7528';
        if (!confirm('\u786e\u5b9a\u8981' + act + '\u8be5\u7528\u6237\u5417\uff1f')) return;
        adminPost('user/status', { userId: id, status: status }, function(res) {
            if (res.code === 200) { showToast(act + '\u6210\u529f'); loadUserList(_userPage); }
            else showToast(res.msg || act + '\u5931\u8d25', 'error');
        });
    }
    </script>
</body>
</html>