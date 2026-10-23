/**
 * 公共JavaScript文件
 */
var basePath = (function() {
    var path = window.location.pathname;
    var idx = path.indexOf('/', 1);
    return idx > 0 ? path.substring(0, idx) : '';
})();
var apiPath = basePath + '/api';
var defaultProductImg = basePath + '/static/images/default-cake.svg';

/** CSRF 令牌由服务端会话签发，写请求通过 X-CSRF-Token 头回传 */
var csrfToken = null;
$.ajaxSetup({
    beforeSend: function(xhr) {
        if (csrfToken) xhr.setRequestHeader('X-CSRF-Token', csrfToken);
    }
});
$.ajax({url: apiPath + '/security/csrf', type: 'GET', dataType: 'json', async: false,
    success: function(r) { if (r && r.code === 200) csrfToken = r.data; }});

/** 输出转义：所有拼进 HTML 的动态值都必须经过这里 */
function esc(value) {
    if (value === null || value === undefined) return '';
    return String(value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

/** 商品图片完整 URL，支持相对路径回退默认图 */
function productImg(path) {
    if (!path) return defaultProductImg;
    var url = path.indexOf('/') === 0 ? basePath + path : path;
    return url + (url.indexOf('?') >= 0 ? '&' : '?') + 't=' + Date.now();
}

function checkLoginStatus() {
    $.ajax({url:apiPath+'/user/info',type:'GET',dataType:'json',
        success:function(r){if(r.code===200&&r.data){$('#userMenu').show();$('#loginBtn').hide();$('#username').text(r.data.username);updateCartCount();
            if(r.data.username==='admin' && !$('#adminEntry').length){
                $('#userMenu .dropdown-menu .dropdown-divider').first().before(
                    '<li><a class="dropdown-item" id="adminEntry" href="'+basePath+'/admin/index.jsp"><i class="bi bi-shield-lock"></i> 后台管理</a></li>');
            }
        }else{$('#userMenu').hide();$('#loginBtn').show();}},
        error:function(){$('#userMenu').hide();$('#loginBtn').show();}});
}

function logout(){$.post(apiPath+'/user/logout',function(){location.reload();});}

function updateCartCount(){$.get(apiPath+'/cart/count',function(r){if(r.code===200)$('#cartCount').text(r.data||0);});}

function addToCart(productId, specId, quantity) {
    $.get(apiPath+'/user/info',function(r){
        if(r.code!==200){if(confirm('请先登录，跳转登录页？'))location.href=basePath+'/user/login.jsp';return;}
        var d={productId:productId,quantity:quantity||1};if(specId)d.specId=specId;
        $.post(apiPath+'/cart/add',d,function(r){if(r.code===200){alert('已添加到购物车');updateCartCount();}else alert(r.msg||'添加失败');});
    });
}

function showToast(msg, type){
    type=type||'success';
    var cls=type==='error'?'bg-danger':'bg-success';
    var h='<div class="toast align-items-center text-white '+cls+' border-0" role="alert"><div class="d-flex"><div class="toast-body">'+msg+'</div><button class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div></div>';
    $('.toast-container').remove();
    var c=$('<div class="toast-container position-fixed top-0 end-0 p-3"></div>');$('body').append(c);c.append(h);
    new bootstrap.Toast(c.find('.toast')[0],{delay:3000}).show();
}

function formatDate(d){if(!d)return'';var t=new Date(d);return t.getFullYear()+'-'+
    String(t.getMonth()+1).padStart(2,'0')+'-'+String(t.getDate()).padStart(2,'0')+' '+
    String(t.getHours()).padStart(2,'0')+':'+String(t.getMinutes()).padStart(2,'0')+':'+String(t.getSeconds()).padStart(2,'0');}

function getOrderStatusText(s){var m={0:'待付款',1:'待发货',2:'待收货',3:'已完成',4:'已取消'};return m[s]||'未知';}
function getOrderStatusClass(s){return'status-'+s;}
function getUrlParam(n){var r=new RegExp('(^|&)'+n+'=([^&]*)(&|$)','i').exec(location.search.substr(1));return r?decodeURIComponent(r[2]):null;}

/** 当前分页回调（供 renderPagination + bindPaginationEvent 联动） */
var _pageCallback = null;

function goToPage(page) {
    if (_pageCallback) _pageCallback(page);
}

function bindPaginationEvent(selector, callback) {
    _pageCallback = callback;
}

function renderPagination(info){
    if(!info||info.totalPages<=1)return'';
    var h='<nav><ul class="pagination justify-content-center">';
    if(info.hasPrev)h+='<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goToPage('+(info.page-1)+')">上一页</a></li>';
    else h+='<li class="page-item disabled"><span class="page-link">上一页</span></li>';
    for(var i=1;i<=info.totalPages;i++){
        if(i===info.page)h+='<li class="page-item active"><span class="page-link">'+i+'</span></li>';
        else if(Math.abs(i-info.page)<=2||i===1||i===info.totalPages)
            h+='<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goToPage('+i+')">'+i+'</a></li>';
        else if(i===2||i===info.totalPages-1)h+='<li class="page-item disabled"><span class="page-link">...</span></li>';
    }
    if(info.hasNext)h+='<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goToPage('+(info.page+1)+')">下一页</a></li>';
    else h+='<li class="page-item disabled"><span class="page-link">下一页</span></li>';
    h+='</ul></nav>';return h;
}
