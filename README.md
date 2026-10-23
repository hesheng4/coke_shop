# 蛋糕商城 (Cake Shop)

基于 JavaEE Web Profile（Servlet 4.0 + JSP/EL/JSTL）的蛋糕商城系统，采用 Controller → Service → DAO 三层架构与 MVC 设计模式，数据源由 Servlet 容器通过 JNDI 托管。

## 技术栈

### 后端
- **Servlet 4.0（javax.servlet）** - 控制器层，`@WebServlet` 注册
- **JSP / EL / JSTL 1.2** - 视图层
- **JavaBean** - 模型层
- **Filter / Listener** - 编码、安全响应头、CSRF、鉴权与会话生命周期
- **JNDI `javax.sql.DataSource`** - 容器托管连接池（Tomcat JDBC Pool）
- **JDBC + PreparedStatement** - 数据访问，自研 `JdbcTemplate` / `TransactionManager`
- **Gson** - JSON 序列化
- **Maven** - 构建打包
- **MySQL 8** - 数据库

### 前端
- **Bootstrap 5** - UI 框架
- **jQuery** - JavaScript 库
- **Ajax** - 异步请求（统一带 `X-CSRF-Token` 头）
- **JSON** - 数据格式

## 架构分层

```
HTTP 请求
  └─ Filter 链（web.xml 声明顺序，确定性排序）
       EncodingFilter → FormBodyParamFilter → SecurityHeadersFilter → CsrfFilter → AccessControlFilter
  └─ Servlet（AbstractApiServlet + ApiRouter 路由表）
  └─ Service 接口 / service.impl 实现（业务规则、多表写入的事务边界）
  └─ DAO 接口 / dao.impl 实现（SQL 常量 + RowMapper）
  └─ JdbcTemplate → DataSource（JNDI 优先，缺失时回落应用内连接池）→ MySQL
```

- **异常收敛**：DAO 抛非受检 `DAOException`，Service 抛 `ServiceException(code, msg)`；`AbstractApiServlet` 统一转成 `{code,msg}` 响应，未预期异常返回 500「服务器繁忙，请稍后重试」并记日志，页面级异常由 `<error-page>` 兜底到 `/error/404.jsp`、`/error/500.jsp`。
- **事务**：`TransactionManager.execute(callback)` 以 ThreadLocal 绑定连接，下单、取消订单等多表写入整体提交或整体回滚；DAO 自动加入当前事务。
- **库存**：扣减 SQL 带 `stock >= ?` 条件，影响行数为 0 即库存不足，抛异常触发整单回滚。

## 项目结构

```
cake_shop/
├── pom.xml                                  # Maven 配置，产物 target/cake-shop.war
├── database/
│   └── init.sql                             # 建库建表 + 初始数据（库名 cakeshop）
├── src/main/
│   ├── java/com/example/cakeshop/
│   │   ├── constant/    SessionKeys          # 会话属性名
│   │   ├── controller/  AbstractApiServlet、User/Product/Category/Cart/Order/Admin、CsrfTokenServlet
│   │   ├── service/     服务接口
│   │   │   └── impl/    服务实现（事务边界）
│   │   ├── dao/         DAO 接口、JdbcTemplate、RowMapper
│   │   │   └── impl/    DAO 实现（SQL）
│   │   ├── ds/          DataSourceFactory、PooledDataSource
│   │   ├── tx/          TransactionManager、TransactionCallback
│   │   ├── filter/      Encoding/FormBodyParam/SecurityHeaders/Csrf/AccessControl
│   │   ├── listener/    AppListener（数据源与配置自检）、UserSessionListener（会话注册表）
│   │   ├── exception/   DAOException、ServiceException
│   │   ├── model/       实体类
│   │   └── util/        ApiRouter、JsonUtil、ResultUtil、PageUtil、PathUtil、SessionUtil、TokenUtil、PasswordUtil、MD5Util、SessionRegistry
│   ├── resources/
│   │   └── db.properties                    # 回落连接池配置（容器未配 JNDI 时使用）
│   └── webapp/
│       ├── WEB-INF/web.xml                  # Filter 链、resource-ref、error-page、session-config
│       ├── META-INF/context.xml             # JNDI 数据源 Resource 定义
│       ├── index.jsp / static/ / user/ / product/ / cart/ / order/ / admin/ / error/
└── README.md
```

## 功能模块

### 用户模块
注册、登录/登出、个人信息管理、收货地址管理（含默认地址）、修改密码

### 商品模块
商品分类、商品列表（分页 / 关键字搜索 / 排序）、商品详情、商品规格

### 购物车模块
加入购物车、列表、修改数量、删除、清空、角标计数

### 订单模块
确认订单、创建订单（事务）、订单列表/详情、模拟支付、取消订单、确认收货、发货

### 后台管理
控制台统计、商品管理、分类管理、订单管理（发货/取消）、用户管理（禁用/启用）

## 快速开始

### 1. 环境要求
- JDK 8+
- Maven 3.6+
- MySQL 8.0（或 5.7）
- **Tomcat 9.x**（Servlet 4.0 / `javax.*`；Tomcat 10+ 使用 `jakarta.*`，本系统不兼容）

### 2. 数据库初始化
```sql
source database/init.sql;   -- 创建库 cakeshop、表结构与初始数据
```

### 3. 数据库配置
主路径是容器托管 JNDI 数据源，定义在 `src/main/webapp/META-INF/context.xml`：

```xml
<Resource name="jdbc/cakeShopDS" auth="Container" type="javax.sql.DataSource"
          factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
          driverClassName="com.mysql.cj.jdbc.Driver"
          url="jdbc:mysql://localhost:3306/cakeshop?useUnicode=true&amp;characterEncoding=utf8&amp;useSSL=false&amp;serverTimezone=Asia/Shanghai&amp;allowPublicKeyRetrieval=true"
          username="root" password="123580" .../>
```

`web.xml` 用 `<resource-ref>jdbc/cakeShopDS</resource-ref>` 引用。改库名/账号/密码只需改这一处，重启 Tomcat 生效。

若容器未配置 JNDI，`DataSourceFactory` 会自动回落到 `src/main/resources/db.properties` + 应用内连接池 `PooledDataSource`，便于在任意 Servlet 容器中直接运行：

```properties
jdbc.url=jdbc:mysql://localhost:3306/cakeshop?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
jdbc.username=root
jdbc.password=123580
jdbc.maxActive=20
```

启动日志会打印实际使用的路径：`已绑定容器 JNDI 数据源 java:comp/env/jdbc/cakeShopDS` 或 `未发现 JNDI 数据源，使用应用内连接池 db.properties`。

### 4. 编译打包
```bash
mvn clean package
```

### 5. 部署运行
把 `target/cake-shop.war` 放入 Tomcat 的 `webapps/` 目录并启动 Tomcat，war 内的 `META-INF/context.xml` 随应用自动生效，上下文路径为 `/cake-shop`。

### 6. 访问系统
- 前台首页: http://localhost:8080/cake-shop/
- 后台管理: http://localhost:8080/cake-shop/admin/index.jsp

### 7. 测试账号
- 管理员: admin / admin123
- 测试用户: testuser / 123456

## API 接口

全部接口以 `/api` 为前缀，路径参数写在 `{}` 中。

### 安全令牌
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/security/csrf | 获取当前会话的 CSRF 令牌 |

### 用户模块
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/user/register | 用户注册 |
| POST | /api/user/login | 用户登录 |
| POST | /api/user/logout | 用户登出 |
| GET | /api/user/info | 获取当前用户信息 |
| PUT | /api/user/info | 更新用户信息 |
| PUT | /api/user/password | 修改密码 |
| GET | /api/user/address | 收货地址列表 |
| POST | /api/user/address | 添加地址 |
| PUT | /api/user/address/{id} | 更新地址（可设为默认） |
| DELETE | /api/user/address/{id} | 删除地址 |

### 商品与分类
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/product/list | 商品列表（page/pageSize/keyword/categoryId/orderBy） |
| GET | /api/product/detail | 商品详情 |
| GET | /api/product/hot | 热销商品 |
| GET | /api/product/new | 新品 |
| GET | /api/product/specs | 商品规格 |
| GET | /api/category/tree、/api/category/list、/api/category/top | 分类树 / 列表 / 一级分类 |
| GET | /api/category/{id} | 分类详情 |
| POST/PUT/DELETE | /api/category、/api/category/{id}[/status] | 分类增删改与启用禁用（仅管理员） |

### 购物车
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/cart/add | 加入购物车 |
| GET | /api/cart/list | 购物车列表 |
| GET | /api/cart/count | 购物车数量（未登录返回 0） |
| PUT | /api/cart/{id} | 修改数量 |
| DELETE | /api/cart/{id} | 删除商品 |

### 订单
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/order/create | 创建订单（事务：扣库存 + 清购物车） |
| GET | /api/order/list | 我的订单 |
| GET | /api/order/detail | 订单详情（仅限本人） |
| POST | /api/order/pay | 支付订单 |
| POST | /api/order/cancel | 取消订单（回补库存） |
| POST | /api/order/confirm | 确认收货 |

### 后台管理
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/admin/index、/api/admin/statistics | 控制台数据 |
| GET | /api/admin/user/list | 用户列表 |
| POST | /api/admin/user/status | 禁用/启用用户（禁止禁用自己） |
| GET | /api/admin/product/list、/api/admin/product/detail | 商品列表（含下架）/ 详情 |
| POST | /api/admin/product/add、update、delete、status | 商品增删改与上下架 |
| GET | /api/admin/order/list、/api/admin/order/detail | 订单列表 / 详情 |
| POST | /api/admin/order/ship、/api/admin/order/cancel | 发货 / 取消 |
| GET | /api/admin/category/list、/api/admin/category/tree | 分类管理列表 / 树 |
| POST | /api/admin/category/add、update、delete、status | 分类增删改与启用禁用 |

## 统一响应格式

```json
{
    "code": 200,
    "msg": "操作成功",
    "data": {}
}
```

分页接口的 `data` 形如 `{"list": [...], "page": {"page":1,"pageSize":10,"totalCount":41,"totalPages":5,"hasPrev":false,"hasNext":true}}`。

### 状态码
| 状态码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 / 业务校验失败 |
| 401 | 未登录 |
| 403 | 无权限（含 CSRF 校验失败） |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

## 安全特性

1. **SQL 注入防护** - 所有 SQL 走 `PreparedStatement` 占位符，`JdbcTemplate` 不接受拼接参数
2. **密码存储** - PBKDF2-HMAC-SHA256 + 每用户随机盐（`PasswordUtil`），迭代 12000 次；数据库中形如 `pbkdf2:迭代:盐:哈希`。历史 MD5 口令仍可登录，登录成功时静默升级为加盐哈希，不改动用户输入的密码
3. **鉴权与授权集中** - `AccessControlFilter` 一处声明登录域（`/api/order`、`/api/cart`、`/api/user/address`、`/api/user/info`、`/api/user/password`）、管理员域（`/api/admin`、分类写接口）与后台页面跳转，Controller 不再各自校验
4. **CSRF 防护** - 会话签发令牌，写接口经 `X-CSRF-Token` 头回传，`CsrfFilter` 常量时间比较；登录/注册等匿名接口豁免
5. **XSS 防护** - 页面为静态壳，数据库文本一律由 Ajax 渲染并经 `common.js` 的 `esc()` 做 HTML 实体转义
6. **会话与响应头** - Cookie `HttpOnly` + `SameSite=Lax`、`tracking-mode=COOKIE`、会话超时 30 分钟；`SecurityHeadersFilter` 统一输出 `X-Content-Type-Options: nosniff`、`X-Frame-Options: SAMEORIGIN`、`Referrer-Policy: same-origin`
7. **序列化保护** - Gson 排除实体的 `password` 字段，接口不会回传口令散列
8. **错误信息收敛** - 数据库异常对外统一为「服务器繁忙，请稍后重试」，堆栈只进服务端日志

## 实现说明与已知限制

- **PUT/DELETE 请求体参数**：Servlet 规范只要求容器解析 POST 表单体，Tomcat 不解析 PUT/DELETE 的 `application/x-www-form-urlencoded` 请求体。`FormBodyParamFilter` 用请求包装器按字节解析这类请求体（先还原 `%XX`，再按请求字符集解码，与容器解析 POST 的行为一致），使 `/api/cart/{id}`、`/api/user/address/{id}` 等接口能直接读到请求体参数。
- **禁用账号即时踢下线**：`UserSessionListener`（`@WebListener`）监听会话中 `user` 属性的新增、替换与移除，把 `userId → session` 登记到 `SessionRegistry`；管理员执行 `/api/admin/user/status` 禁用某账号时调用 `SessionRegistry.logout(userId)`，立即作废该用户名下的全部会话，对方下一次请求即返回 401。注册表用 `ConcurrentHashMap` 存储，会话销毁或属性被替换时同步清理，不影响操作者自身会话。
- **规格库存精确回补**：`order_item` 含 `spec_id` 列（新库由 `database/init.sql` 直接创建；已有数据库需执行 `ALTER TABLE order_item ADD COLUMN spec_id INT DEFAULT NULL;`）。下单时把 `cart.spec_id` 写入订单明细，取消订单在同一事务内除回补商品总库存与销量外，对 `spec_id` 非空的明细调用 `ProductDao.restoreSpecStock` 回补 `product_spec.stock`。
- **模拟支付**：`/api/order/pay` 只做状态流转（`status` 0→1、写 `pay_time`），不接支付网关。

## 浏览器支持

- Chrome 60+
- Firefox 60+
- Safari 12+
- Edge 79+

## 许可证

MIT License
