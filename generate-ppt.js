const pptxgen = require("pptxgenjs");

let pres = new pptxgen();
pres.layout = "LAYOUT_16x9";
pres.author = "Cake Shop Project";
pres.title = "蛋糕商城系统 - 项目演示";

// Color palette: Charcoal Minimal (Gray Theme)
const C = {
  berry: "2D2D2D",
  rose: "5A5A5A",
  cream: "E8E8E8",
  white: "FFFFFF",
  dark: "1E1E1E",
  text: "333333",
  lightText: "BBBBBB",
  accent: "6B8E9F",
  green: "4A7C59",
  blue: "4A6FA5"
};

// ===== Helper: Title bar =====
function addTitle(slide, title) {
  slide.background = { color: C.cream };
  slide.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.9, fill: { color: C.berry } });
  slide.addText(title, { x: 0.5, y: 0.18, w: 9, h: 0.6, fontSize: 32, bold: true, color: C.white, align: "left", fontFace: "Arial" });
}

// ===== Helper: Code box =====
function addCodeBox(slide, x, y, w, h, codeLines) {
  slide.addShape(pres.shapes.RECTANGLE, { x, y, w, h, fill: { color: C.dark } });
  slide.addText(codeLines, { x: x + 0.05, y: y + 0.08, w: w - 0.1, h: h - 0.15, fontFace: "Consolas" });
}

// ===== Helper: Info box =====
function addInfoBox(slide, x, y, w, h, title, bullets) {
  slide.addShape(pres.shapes.RECTANGLE, { x, y, w, h, fill: { color: C.white }, shadow: { type: "outer", color: "000000", blur: 6, offset: 2, angle: 135, opacity: 0.1 } });
  slide.addText(title, { x: x + 0.15, y: y + 0.12, w: w - 0.3, h: 0.4, fontSize: 18, bold: true, color: C.berry, fontFace: "Arial" });
  slide.addText(bullets, { x: x + 0.15, y: y + 0.55, w: w - 0.3, h: h - 0.7, fontFace: "Arial" });
}

// ========== Slide 1: Cover ==========
let s1 = pres.addSlide();
s1.background = { color: C.berry };
s1.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 5.625, fill: { color: C.berry } });
s1.addShape(pres.shapes.OVAL, { x: 7.5, y: -1, w: 4, h: 4, fill: { color: C.rose, transparency: 40 } });
s1.addShape(pres.shapes.OVAL, { x: -1, y: 3.5, w: 3, h: 3, fill: { color: C.accent, transparency: 30 } });
s1.addText("蛋糕商城系统", { x: 0.5, y: 1.8, w: 9, h: 1.2, fontSize: 54, bold: true, color: C.white, align: "center", fontFace: "Arial" });
s1.addText("基于 Java Web 的电商项目演示", { x: 0.5, y: 3.1, w: 9, h: 0.6, fontSize: 22, color: C.lightText, align: "center", fontFace: "Arial" });
s1.addText("Servlet + JSP + MySQL + Maven", { x: 0.5, y: 3.8, w: 9, h: 0.5, fontSize: 16, color: C.accent, align: "center", fontFace: "Arial" });

// ========== Slide 2: Overview ==========
let s2 = pres.addSlide();
addTitle(s2, "项目概述");
addInfoBox(s2, 0.5, 1.2, 4.2, 4.0, "功能模块", [
  { text: "用户模块：注册、登录、个人信息管理", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "商品模块：分类浏览、搜索、排序、详情", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "购物车模块：增删改查、数量调整", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "订单模块：创建、支付、取消、确认收货", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "后台管理：数据统计、商品/订单/用户管理", options: { bullet: true, fontSize: 14, color: C.text } }
]);
addInfoBox(s2, 5.3, 1.2, 4.2, 4.0, "技术栈", [
  { text: "后端：Servlet 4.0 / JSP / JSTL / JDBC", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "数据库：MySQL 8.0 + PreparedStatement", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "构建：Maven 3.11", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "前端：Bootstrap 5 / jQuery / Ajax / JSON", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "安全：MD5加盐 / SQL注入防护 / Session鉴权", options: { bullet: true, fontSize: 14, color: C.text } }
]);

// ========== Slide 3: Background ==========
let s3 = pres.addSlide();
addTitle(s3, "项目背景与选题意义");
addInfoBox(s3, 0.5, 1.2, 4.2, 4.0, "背景", [
  { text: "随着互联网的发展，线上购物已成为主流消费方式", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "蛋糕等烘焙食品的线上订购需求逐年增长", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "传统电话预订方式效率低、管理难", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "需要一套完整的电商系统来支撑线上业务", options: { bullet: true, fontSize: 14, color: C.text } }
]);
addInfoBox(s3, 5.3, 1.2, 4.2, 4.0, "意义", [
  { text: "巩固 Java Web 核心技术（Servlet/JSP/JDBC）", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "实践三层架构与 MVC 设计模式", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "掌握前后端分离交互（JSON + Ajax）", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "为后续学习 SSM / Spring Boot 打下基础", options: { bullet: true, fontSize: 14, color: C.text } }
]);

// ========== Slide 4: Maven Config ==========
let s4 = pres.addSlide();
addTitle(s4, "Maven 配置 - pom.xml");
addCodeBox(s4, 0.5, 1.1, 5.5, 4.2, [
  { text: "<project>", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  <groupId>com.example</groupId>", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  <artifactId>cake-shop</artifactId>", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  <packaging>war</packaging>", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  <dependencies>", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    <!-- Servlet API -->", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    <dependency>", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      <groupId>javax.servlet</groupId>", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      <artifactId>javax.servlet-api</artifactId>", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      <version>4.0.1</version>", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    </dependency>", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    <!-- MySQL + JSTL + Gson + JUnit -->", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "  </dependencies>", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "</project>", options: { fontSize: 11, color: "A26769" } }
]);
addInfoBox(s4, 6.2, 1.1, 3.3, 4.2, "说明", [
  { text: "packaging 为 war，用于部署到 Tomcat", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "Servlet API scope 设为 provided，运行时由容器提供", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "mysql-connector-java 8.0.33 连接 MySQL", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "Gson 2.10.1 用于 Java 对象与 JSON 互转", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "JSTL 简化 JSP 页面逻辑", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 5: Architecture ==========
let s5 = pres.addSlide();
addTitle(s5, "项目架构（三层架构 + MVC）");
let layers5 = [
  { label: "表现层 (View)", sub: "JSP / HTML / JS\nBootstrap + jQuery", x: 0.3, fill: "A26769" },
  { label: "控制层 (Controller)", sub: "Servlet\nRESTful API", x: 2.1, fill: "D4A373" },
  { label: "业务层 (Service)", sub: "业务逻辑处理\n事务控制", x: 3.9, fill: "A26769" },
  { label: "数据层 (DAO)", sub: "JDBC + MySQL\nPreparedStatement", x: 5.7, fill: "D4A373" }
];
layers5.forEach((l, i) => {
  s5.addShape(pres.shapes.RECTANGLE, { x: l.x, y: 1.8, w: 1.6, h: 2.6, fill: { color: l.fill } });
  s5.addText(l.label, { x: l.x, y: 2.3, w: 1.6, h: 0.5, fontSize: 13, bold: true, color: C.white, align: "center", valign: "middle", fontFace: "Arial" });
  s5.addText(l.sub, { x: l.x, y: 2.9, w: 1.6, h: 1.0, fontSize: 11, color: C.lightText, align: "center", valign: "middle", fontFace: "Arial" });
  if (i < layers5.length - 1) {
    s5.addShape(pres.shapes.LINE, { x: l.x + 1.6, y: 3.1, w: 0.6, h: 0, line: { color: C.berry, width: 2 } });
    s5.addText("→", { x: l.x + 1.6, y: 2.9, w: 0.6, h: 0.4, fontSize: 16, color: C.berry, align: "center", valign: "middle" });
  }
});
s5.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 4.7, w: 9, h: 0.7, fill: { color: C.white } });
s5.addText("优势：各层职责清晰，便于维护扩展；Servlet 通过 @WebServlet 注解映射 URL，前端通过 Ajax 调用 JSON 接口实现前后端分离交互。", { x: 0.6, y: 4.75, w: 8.8, h: 0.6, fontSize: 13, color: C.text, fontFace: "Arial" });

// ========== Slide 6: Package Structure ==========
let s6 = pres.addSlide();
addTitle(s6, "项目包结构");
addCodeBox(s6, 0.5, 1.1, 5.5, 4.2, [
  { text: "src/main/java/com/example/cakeshop/", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  controller/          # Servlet 控制器", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    UserController.java", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    ProductController.java", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    CartController.java", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    OrderController.java", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    AdminController.java", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  service/             # 业务逻辑层", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  dao/                 # 数据访问层", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  model/               # 实体类（JavaBean）", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  util/                # 工具类", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  filter/              # 过滤器", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "src/main/resources/db.properties", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "src/main/webapp/       # JSP + 静态资源", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "database/init.sql      # 数据库初始化脚本", options: { fontSize: 11, color: C.lightText } }
]);
addInfoBox(s6, 6.2, 1.1, 3.3, 4.2, "设计规范", [
  { text: "controller：接收请求、参数校验、返回 JSON", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "service：业务逻辑编排、事务控制", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "dao：直接操作数据库，单表 CRUD", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "model：纯数据实体，与数据库表对应", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "util：通用工具，各层均可调用", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 7: ER Diagram ==========
let s7 = pres.addSlide();
addTitle(s7, "数据库 ER 关系图");
let erTables = [
  { name: "user", x: 0.5, y: 1.4, w: 1.8, h: 1.0 },
  { name: "category", x: 2.8, y: 1.4, w: 1.8, h: 1.0 },
  { name: "product", x: 5.1, y: 1.4, w: 1.8, h: 1.0 },
  { name: "product_spec", x: 7.4, y: 1.4, w: 1.8, h: 1.0 },
  { name: "cart", x: 0.5, y: 2.8, w: 1.8, h: 1.0 },
  { name: "order", x: 2.8, y: 2.8, w: 1.8, h: 1.0 },
  { name: "order_item", x: 5.1, y: 2.8, w: 1.8, h: 1.0 },
  { name: "address", x: 7.4, y: 2.8, w: 1.8, h: 1.0 },
  { name: "review", x: 0.5, y: 4.2, w: 1.8, h: 1.0 },
  { name: "coupon", x: 2.8, y: 4.2, w: 1.8, h: 1.0 },
  { name: "user_coupon", x: 5.1, y: 4.2, w: 1.8, h: 1.0 }
];
erTables.forEach(t => {
  s7.addShape(pres.shapes.RECTANGLE, { x: t.x, y: t.y, w: t.w, h: t.h, fill: { color: C.berry } });
  s7.addText(t.name, { x: t.x, y: t.y, w: t.w, h: t.h, fontSize: 12, bold: true, color: C.white, align: "center", valign: "middle", fontFace: "Arial" });
});
// Relationships
s7.addShape(pres.shapes.LINE, { x: 2.3, y: 1.9, w: 0.5, h: 0, line: { color: C.rose, width: 2 } });
s7.addShape(pres.shapes.LINE, { x: 4.6, y: 1.9, w: 0.5, h: 0, line: { color: C.rose, width: 2 } });
s7.addShape(pres.shapes.LINE, { x: 6.9, y: 1.9, w: 0.5, h: 0, line: { color: C.rose, width: 2 } });
s7.addShape(pres.shapes.LINE, { x: 1.4, y: 2.4, w: 0, h: 0.4, line: { color: C.rose, width: 2 } });
s7.addShape(pres.shapes.LINE, { x: 3.7, y: 2.4, w: 0, h: 0.4, line: { color: C.rose, width: 2 } });
s7.addShape(pres.shapes.LINE, { x: 6.0, y: 2.4, w: 0, h: 0.4, line: { color: C.rose, width: 2 } });
s7.addShape(pres.shapes.LINE, { x: 8.3, y: 2.4, w: 0, h: 0.4, line: { color: C.rose, width: 2 } });
s7.addShape(pres.shapes.LINE, { x: 1.4, y: 3.8, w: 0, h: 0.4, line: { color: C.rose, width: 2 } });
s7.addShape(pres.shapes.LINE, { x: 3.7, y: 3.8, w: 0, h: 0.4, line: { color: C.rose, width: 2 } });
s7.addShape(pres.shapes.LINE, { x: 6.0, y: 3.8, w: 0, h: 0.4, line: { color: C.rose, width: 2 } });

// ========== Slide 8: Database Tables ==========
let s8 = pres.addSlide();
addTitle(s8, "数据库设计 - 核心表结构");
let tableData8 = [
  [{ text: "表名", options: { fill: { color: C.berry }, color: C.white, bold: true } }, { text: "说明", options: { fill: { color: C.berry }, color: C.white, bold: true } }],
  ["user", "用户表（MD5加密密码）"],
  ["category", "商品分类表（支持多级）"],
  ["product", "商品表（价格/库存/状态）"],
  ["product_spec", "商品规格表（尺寸/口味）"],
  ["cart", "购物车表"],
  ["order / order_item", "订单/订单明细表"],
  ["address", "收货地址表"],
  ["review", "商品评价表"],
  ["coupon", "优惠券表"]
];
s8.addTable(tableData8, { x: 0.5, y: 1.2, w: 4.2, h: 3.8, colW: [1.8, 2.4], border: { pt: 0.5, color: "C0B0A0" }, fill: { color: C.white }, fontFace: "Arial", fontSize: 12, color: C.text });
addCodeBox(s8, 5.0, 1.2, 4.5, 3.8, [
  { text: "用户表建表 SQL", options: { breakLine: true, fontSize: 12, bold: true, color: C.accent } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "CREATE TABLE IF NOT EXISTS `user` (", options: { breakLine: true, fontSize: 10, color: "A26769" } },
  { text: "  `id` INT PRIMARY KEY AUTO_INCREMENT,", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "  `username` VARCHAR(50) NOT NULL UNIQUE,", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "  `password` VARCHAR(100) NOT NULL,", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "  `email` VARCHAR(100),", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "  `phone` VARCHAR(20),", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "  `status` TINYINT DEFAULT 1,", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "    ON UPDATE CURRENT_TIMESTAMP", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;", options: { fontSize: 10, color: "A26769" } }
]);

// ========== Slide 9: Model Layer ==========
let s9 = pres.addSlide();
addTitle(s9, "实体层 - User.java & Product.java");
addCodeBox(s9, 0.5, 1.2, 4.5, 3.8, [
  { text: "public class User {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  private Integer id;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private String username;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private String password;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private String email;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private String phone;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private String avatar;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private Integer status;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private Date createTime;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private Date updateTime;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  // Getters, Setters, toString", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
addCodeBox(s9, 5.2, 1.2, 4.3, 3.8, [
  { text: "public class Product {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  private Integer id;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private String name;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private BigDecimal price;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private Integer stock;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private Integer sales;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private String image;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  // 关联字段", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "  private String categoryName;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private List<ProductSpec> specs;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
s9.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 5.15, w: 9, h: 0.35, fill: { color: C.white } });
s9.addText("说明：实体类与数据库表一一对应，采用 JavaBean 规范。Product 包含关联字段用于联表查询封装。", { x: 0.6, y: 5.18, w: 8.8, h: 0.3, fontSize: 12, color: C.text, fontFace: "Arial" });

// ========== Slide 10: DBUtil ==========
let s10 = pres.addSlide();
addTitle(s10, "数据库连接工具 - DBUtil.java");
addCodeBox(s10, 0.5, 1.1, 5.5, 4.2, [
  { text: "public class DBUtil {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  static {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    Properties props = new Properties();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    InputStream is = DBUtil.class", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      .getClassLoader()", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      .getResourceAsStream(\"db.properties\");", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    props.load(is);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    Class.forName(props.getProperty(\"jdbc.driver\"));", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  public static Connection getConnection()", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      throws SQLException {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    return DriverManager.getConnection(url, user, pwd);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  public static void close(Connection conn,", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "                           Statement stmt, ResultSet rs) { ... }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
addInfoBox(s10, 6.2, 1.1, 3.3, 4.2, "设计要点", [
  { text: "静态代码块加载配置文件，实现配置与代码分离", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "使用 Properties 读取外部配置，便于部署时修改", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "提供统一的 close 方法，防止连接泄漏", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "后续可扩展为数据库连接池（Druid/HikariCP）", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 11: DAO Layer ==========
let s11 = pres.addSlide();
addTitle(s11, "数据访问层 - UserDao.java");
addCodeBox(s11, 0.5, 1.1, 5.5, 4.2, [
  { text: "public class UserDao {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  public int insert(User user) throws SQLException {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    String sql = \"INSERT INTO user (...) VALUES (?, ?, ...)\";", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    Connection conn = DBUtil.getConnection();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    PreparedStatement pstmt = conn.prepareStatement(sql,", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "        Statement.RETURN_GENERATED_KEYS);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    pstmt.setString(1, user.getUsername());", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    pstmt.setString(2, user.getPassword());", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    pstmt.executeUpdate();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    rs = pstmt.getGeneratedKeys();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    if (rs.next()) return rs.getInt(1);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  public User findByUsername(String username) { ... }", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
addInfoBox(s11, 6.2, 1.1, 3.3, 4.2, "DAO 设计要点", [
  { text: "PreparedStatement 使用 ? 占位符，天然防 SQL 注入", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "finally 块中统一调用 DBUtil.close() 释放资源", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "Statement.RETURN_GENERATED_KEYS 获取自增主键", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "mapRow() 私有方法封装 ResultSet → 对象转换", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 12: ProductDao ==========
let s12 = pres.addSlide();
addTitle(s12, "数据访问层 - ProductDao.java（联表查询）");
addCodeBox(s12, 0.5, 1.1, 5.5, 4.2, [
  { text: "public class ProductDao {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  public List<Product> findAll(Integer catId,", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "                             String keyword,", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "                             String orderBy,", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "                             int offset, int size)", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "                             throws SQLException {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    String sql = \"SELECT p.*, c.name AS category_name \";", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    sql += \"FROM product p LEFT JOIN category c \";", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    sql += \"ON p.category_id = c.id WHERE p.status=1\";", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    if (catId != null) sql += \" AND p.category_id=?\";", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    if (keyword != null) sql += \" AND p.name LIKE ?\";", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    sql += \" LIMIT ?, ?\";", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    // ... PreparedStatement 设置参数", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
addInfoBox(s12, 6.2, 1.1, 3.3, 4.2, "联表查询要点", [
  { text: "LEFT JOIN category 获取商品分类名称", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "动态 SQL：根据参数拼接 WHERE 条件", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "LIKE ? 配合 %keyword% 实现模糊搜索", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "LIMIT offset, size 实现分页查询", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "ORDER BY 支持按价格/销量/时间排序", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 13: Service Layer ==========
let s13 = pres.addSlide();
addTitle(s13, "业务层 - UserService.java");
addCodeBox(s13, 0.5, 1.1, 5.5, 4.2, [
  { text: "public class UserService {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  private UserDao userDao = new UserDao();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "  public boolean register(User user) throws SQLException {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    if (userDao.existsByUsername(user.getUsername()))", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      return false;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    // MD5 加密密码", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    user.setPassword(MD5Util.md5(user.getPassword()));", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    user.setStatus(1);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    return userDao.insert(user) > 0;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "  public User login(String username, String pwd)", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      throws SQLException {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    User user = userDao.findByUsername(username);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    if (user == null) return null;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    String md5Pwd = MD5Util.md5(pwd);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    if (!md5Pwd.equals(user.getPassword()))", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      return null;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    return user;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
addInfoBox(s13, 6.2, 1.1, 3.3, 4.2, "Service 职责", [
  { text: "封装业务逻辑，供 Controller 直接调用", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "注册时先检查用户名是否存在", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "登录时比对 MD5 加密后的密码", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "Controller 不直接调用 DAO，解耦数据访问", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 14: ResultUtil ==========
let s14 = pres.addSlide();
addTitle(s14, "工具类 - ResultUtil & MD5Util");
addCodeBox(s14, 0.5, 1.1, 4.4, 4.2, [
  { text: "public class ResultUtil {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  public static Map success(Object data) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    Map result = new HashMap<>();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    result.put(\"code\", 200);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    result.put(\"msg\", \"操作成功\");", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    result.put(\"data\", data);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    return result;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  public static Map error(int code, String msg) { ... }", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
addCodeBox(s14, 5.1, 1.1, 4.4, 4.2, [
  { text: "public class MD5Util {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  public static String md5(String str) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    MessageDigest md =", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "        MessageDigest.getInstance(\"MD5\");", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    md.update(str.getBytes());", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    byte[] digest = md.digest();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    // 转换为 32 位十六进制字符串", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    return buf.toString();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  public static String md5WithSalt(String str,", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "                                    String salt) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    return md5(str + salt);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
s14.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 5.35, w: 9, h: 0.2, fill: { color: C.white } });
s14.addText("响应格式统一：{\"code\":200, \"msg\":\"操作成功\", \"data\":{}}  状态码：200成功 / 400参数错误 / 401未登录 / 403无权限 / 500服务器错误", { x: 0.6, y: 5.38, w: 8.8, h: 0.15, fontSize: 11, color: C.text, fontFace: "Arial" });

// ========== Slide 15: UserController ==========
let s15 = pres.addSlide();
addTitle(s15, "控制器层 - UserController.java");
addCodeBox(s15, 0.5, 1.1, 5.5, 4.2, [
  { text: "@WebServlet(\"/api/user/*\")", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "public class UserController extends HttpServlet {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  protected void doPost(req, resp) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    String path = PathUtil.cleanPath(req.getPathInfo());", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    if (\"register\".equals(path)) register(req, resp);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    else if (\"login\".equals(path)) login(req, resp);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    else if (\"logout\".equals(path)) logout(req, resp);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  private void login(...) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    User user = userService.login(username, password);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    if (user != null) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      req.getSession().setAttribute(\"user\", user);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      JsonUtil.writeSuccess(resp, \"登录成功\", user);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
addInfoBox(s15, 6.2, 1.1, 3.3, 4.2, "Servlet 设计要点", [
  { text: "@WebServlet 注解配置，无需 web.xml", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "RESTful 风格：GET/POST/PUT/DELETE 对应查/增/改/删", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "Session 鉴权：登录成功后存入 Session，后续接口校验", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "统一 JSON 输出：通过 JsonUtil 返回标准格式", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "参数校验：非空、长度等基础校验在 Controller 完成", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 16: ProductController ==========
let s16 = pres.addSlide();
addTitle(s16, "控制器层 - ProductController.java");
addCodeBox(s16, 0.5, 1.1, 5.5, 4.2, [
  { text: "@WebServlet(\"/api/product/*\")", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "private void getProductList(...) {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  String keyword = req.getParameter(\"keyword\");", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  String pageStr = req.getParameter(\"page\");", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  int page = 1, pageSize = 10;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  try {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    if (pageStr != null) page = Integer.parseInt(pageStr);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  } catch (NumberFormatException e) { /* 默认值 */ }", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "  PageUtil pageUtil = new PageUtil(page, pageSize);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  List<Product> products = productService.findAll(...);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  int totalCount = productService.count(...);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  pageUtil.setTotalCount(totalCount);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  result.put(\"list\", products);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  result.put(\"page\", pageUtil.getPageInfo());", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  JsonUtil.writeSuccess(resp, result);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
addInfoBox(s16, 6.2, 1.1, 3.3, 4.2, "分页与搜索", [
  { text: "从 URL 参数获取分类、关键词、排序、页码", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "页码解析失败时使用默认值，防止程序崩溃", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "PageUtil 封装：统一计算总页数、偏移量", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "Service 层调用 DAO 多表关联获取数据", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 17: CartController ==========
let s17 = pres.addSlide();
addTitle(s17, "控制器层 - CartController.java");
addCodeBox(s17, 0.5, 1.1, 5.5, 4.2, [
  { text: "@WebServlet(\"/api/cart/*\")", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "public class CartController extends HttpServlet {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "  private void addToCart(...) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    User user = getLoginUser(req);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    int productId = Integer.parseInt(req.getParameter(\"productId\"));", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    int quantity = Integer.parseInt(req.getParameter(\"quantity\"));", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    Cart cart = cartDao.findByUserAndProduct(user.getId(), productId);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    if (cart != null) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      // 已存在则累加数量", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "      cartDao.updateQuantity(cart.getId(), cart.getQuantity() + quantity);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    } else {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      // 新增购物车记录", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "      cartDao.insert(new Cart(user.getId(), productId, quantity));", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    JsonUtil.writeSuccess(resp, \"添加成功\");", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
addInfoBox(s17, 6.2, 1.1, 3.3, 4.2, "购物车逻辑", [
  { text: "判断商品是否已在购物车中", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "存在则累加数量，不存在则新增记录", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "校验商品库存是否充足", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "统一返回购物车商品总数", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "PUT /cart/{id} 修改数量，DELETE /cart/{id} 删除", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 18: OrderController ==========
let s18 = pres.addSlide();
addTitle(s18, "控制器层 - OrderController.java");
addCodeBox(s18, 0.5, 1.1, 5.5, 4.2, [
  { text: "@WebServlet(\"/api/order/*\")", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "public class OrderController extends HttpServlet {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "  private void createOrder(...) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    User user = getLoginUser(req);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    // 获取购物车选中的商品", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    List<Cart> carts = cartDao.findSelected(user.getId());", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    // 计算总金额", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    BigDecimal total = calculateTotal(carts);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    // 生成订单号", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    String orderNo = generateOrderNo();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    // 插入订单 + 订单明细", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    orderDao.insert(order);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    orderItemDao.batchInsert(items);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    // 扣减库存", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    productDao.deductStock(...);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    JsonUtil.writeSuccess(resp, \"订单创建成功\");", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
addInfoBox(s18, 6.2, 1.1, 3.3, 4.2, "订单核心流程", [
  { text: "从购物车获取选中商品生成订单", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "生成唯一订单号（时间戳+随机数）", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "同时插入 order 和 order_item 表", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "扣减对应商品库存", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "后续可扩展事务控制保证一致性", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 19: AdminController ==========
let s19 = pres.addSlide();
addTitle(s19, "后台管理 - AdminController.java");
addCodeBox(s19, 0.5, 1.1, 5.5, 4.2, [
  { text: "@WebServlet(\"/api/admin/*\")", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "public class AdminController extends HttpServlet {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "  private void getStatistics(...) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    // 统计面板数据", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    int userCount = userDao.count();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    int productCount = productDao.count();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    int orderCount = orderDao.count();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    BigDecimal totalSales = orderDao.totalSales();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    Map<String, Object> data = new HashMap<>();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    data.put(\"userCount\", userCount);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    data.put(\"productCount\", productCount);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    data.put(\"orderCount\", orderCount);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    data.put(\"totalSales\", totalSales);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    JsonUtil.writeSuccess(resp, data);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "  // /admin/product/list, /admin/order/list", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "  // /admin/order/ship, /admin/user/status", options: { fontSize: 11, color: "D4A373" } }
]);
addInfoBox(s19, 6.2, 1.1, 3.3, 4.2, "后台功能", [
  { text: "控制台：用户/商品/订单数量统计", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "商品管理：上架、下架、编辑商品", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "订单管理：查看订单列表、发货处理", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "用户管理：查看用户列表、禁用/启用", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "管理员鉴权：Filter 拦截非 admin 用户", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 20: Filter ==========
let s20 = pres.addSlide();
addTitle(s20, "安全机制 - LoginFilter.java");
addCodeBox(s20, 0.5, 1.1, 5.5, 4.2, [
  { text: "@WebFilter(\"/api/user/*\")", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "public class LoginFilter implements Filter {", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  public void doFilter(req, resp, chain) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    HttpServletRequest request = (HttpServletRequest) req;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    HttpServletResponse response = (HttpServletResponse) resp;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    HttpSession session = request.getSession(false);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    // 白名单：登录/注册接口放行", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    String path = request.getRequestURI();", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    if (path.contains(\"login\") || path.contains(\"register\")) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      chain.doFilter(req, resp);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      return;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    // 校验登录状态", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    if (session == null || session.getAttribute(\"user\") == null) {", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      JsonUtil.writeError(response, 401, \"请先登录\");", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "      return;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "    chain.doFilter(req, resp);", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "}", options: { fontSize: 11, color: "A26769" } }
]);
addInfoBox(s20, 6.2, 1.1, 3.3, 4.2, "安全机制", [
  { text: "Filter 拦截所有 /api/user/* 请求", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "白名单放行登录/注册接口", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "未登录返回 401，前端跳转登录页", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "AdminFilter 额外校验管理员权限", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "所有 DAO 使用 PreparedStatement 防注入", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 21: Frontend Ajax ==========
let s21 = pres.addSlide();
addTitle(s21, "前端交互 - JSP + Ajax");
addCodeBox(s21, 0.5, 1.1, 4.5, 2.2, [
  { text: "后端返回 JSON", options: { breakLine: true, fontSize: 12, bold: true, color: C.accent } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "resp.setContentType(\"application/json;charset=UTF-8\");", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "Map result = ResultUtil.success(msg, data);", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "resp.getWriter().write(new Gson().toJson(result));", options: { breakLine: true, fontSize: 10, color: C.lightText } }
]);
addCodeBox(s21, 0.5, 3.5, 4.5, 1.8, [
  { text: "前端 Ajax 调用", options: { breakLine: true, fontSize: 12, bold: true, color: C.accent } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "$.ajax({", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "  url: 'api/user/login', type: 'POST',", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "  data: { username: name, password: pwd },", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "  success: function(res) {", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "    if (res.code === 200) { ... }", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "    else { alert(res.msg); }", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "  }", options: { breakLine: true, fontSize: 10, color: C.lightText } },
  { text: "});", options: { fontSize: 10, color: C.lightText } }
]);
addInfoBox(s21, 5.2, 1.1, 4.3, 4.2, "前后端交互流程", [
  { text: "1. 用户操作：点击按钮/提交表单", options: { breakLine: true, fontSize: 13, color: C.text } },
  { text: "2. Ajax 请求：前端发送异步 HTTP 请求", options: { breakLine: true, fontSize: 13, color: C.text } },
  { text: "3. Servlet 接收：Controller 解析参数、调用 Service", options: { breakLine: true, fontSize: 13, color: C.text } },
  { text: "4. 业务处理：Service 处理逻辑、DAO 操作数据库", options: { breakLine: true, fontSize: 13, color: C.text } },
  { text: "5. JSON 响应：后端返回统一格式 JSON", options: { breakLine: true, fontSize: 13, color: C.text } },
  { text: "6. 前端渲染：根据 code 判断是否成功，更新页面", options: { breakLine: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 22: Pages ==========
let s22 = pres.addSlide();
addTitle(s22, "前端页面结构");
addCodeBox(s22, 0.5, 1.1, 5.5, 4.2, [
  { text: "webapp/", options: { breakLine: true, fontSize: 11, color: "A26769" } },
  { text: "  index.jsp            # 首页（商品列表、轮播图）", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  product/list.jsp     # 商品列表页（分类、搜索、分页）", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  product/detail.jsp   # 商品详情页（规格选择）", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  cart/list.jsp        # 购物车页", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  order/confirm.jsp    # 订单确认页（地址选择）", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  order/list.jsp       # 订单列表页", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  user/info.jsp        # 个人信息页", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  user/address.jsp     # 收货地址管理", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  admin/index.jsp      # 后台管理首页（控制台）", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  admin/product.jsp    # 后台商品管理", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  admin/order.jsp      # 后台订单管理", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "  static/", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "    css/  js/  images/  # 静态资源", options: { fontSize: 11, color: C.lightText } }
]);
addInfoBox(s22, 6.2, 1.1, 3.3, 4.2, "页面说明", [
  { text: "JSP 页面通过 JSTL 循环渲染数据列表", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "静态页面通过 Ajax 加载 JSON 数据", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "Bootstrap 5 实现响应式布局", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "jQuery 简化 DOM 操作和事件绑定", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "前后端混合模式 + 前后端分离模式并存", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 23: Deploy ==========
let s23 = pres.addSlide();
addTitle(s23, "项目部署与运行");
addCodeBox(s23, 0.5, 1.1, 5.5, 4.2, [
  { text: "# 1. 环境要求", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "JDK 1.8+ / Maven 3.6+ / MySQL 5.7+ / Tomcat 8.5+", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "# 2. 数据库初始化", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "mysql> source database/init.sql;", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "# 3. 修改数据库配置", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "src/main/resources/db.properties", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "jdbc.url=jdbc:mysql://localhost:3306/cakeshop", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "jdbc.username=root", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "jdbc.password=123580", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "# 4. 编译打包", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "mvn clean package", options: { breakLine: true, fontSize: 11, color: C.lightText } },
  { text: "", options: { breakLine: true, fontSize: 6, color: C.lightText } },
  { text: "# 5. 部署到 Tomcat", options: { breakLine: true, fontSize: 11, color: "D4A373" } },
  { text: "cp target/cake-shop.war $TOMCAT/webapps/", options: { fontSize: 11, color: C.lightText } }
]);
addInfoBox(s23, 6.2, 1.1, 3.3, 4.2, "测试账号", [
  { text: "管理员: admin / admin123", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "测试用户: testuser / 123456", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "前台: http://localhost:8080/cake-shop/", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "后台: http://localhost:8080/cake-shop/admin/", options: { bullet: true, breakLine: true, fontSize: 14, color: C.text } },
  { text: "密码均使用 MD5 加密存储", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 24: Problems ==========
let s24 = pres.addSlide();
addTitle(s24, "遇到的问题与解决方案");
addInfoBox(s24, 0.5, 1.2, 4.2, 4.0, "问题", [
  { text: "中文乱码：请求/响应编码不一致", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "路径解析：pathInfo 带 .jsp 后缀导致匹配失败", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "事务控制：订单创建涉及多张表，缺少回滚机制", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "并发安全：库存扣减存在超卖风险", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "代码复用：各 DAO 重复编写连接和关闭逻辑", options: { bullet: true, fontSize: 13, color: C.text } }
]);
addInfoBox(s24, 5.3, 1.2, 4.2, 4.0, "解决方案", [
  { text: "统一设置 request.setCharacterEncoding(\"UTF-8\")", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "cleanPath() 方法去除 .jsp 后缀", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "后续引入 Spring 的 @Transactional", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "使用乐观锁（version 字段）或数据库行锁", options: { bullet: true, breakLine: true, fontSize: 13, color: C.text } },
  { text: "DBUtil 工具类封装通用 JDBC 操作", options: { bullet: true, fontSize: 13, color: C.text } }
]);

// ========== Slide 25: Summary ==========
let s25 = pres.addSlide();
s25.background = { color: C.berry };
s25.addShape(pres.shapes.OVAL, { x: 7.5, y: -1, w: 4, h: 4, fill: { color: C.rose, transparency: 40 } });
s25.addShape(pres.shapes.OVAL, { x: -1, y: 3.5, w: 3, h: 3, fill: { color: C.accent, transparency: 30 } });
s25.addText("项目总结与展望", { x: 0.5, y: 0.5, w: 9, h: 1, fontSize: 44, bold: true, color: C.white, align: "center", fontFace: "Arial" });
s25.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 1.7, w: 4.2, h: 3.4, fill: { color: C.cream } });
s25.addText("核心技术点", { x: 0.7, y: 1.85, w: 3.8, h: 0.4, fontSize: 18, bold: true, color: C.berry, fontFace: "Arial" });
let core25 = [
  { text: "三层架构：表现层、控制层、业务层、数据层职责分离", options: { bullet: true, breakLine: true, fontSize: 12, color: C.text } },
  { text: "MVC 模式：Servlet(Controller) + JSP(View) + JavaBean(Model)", options: { bullet: true, breakLine: true, fontSize: 12, color: C.text } },
  { text: "JDBC 封装：DBUtil 统一连接管理和资源释放", options: { bullet: true, breakLine: true, fontSize: 12, color: C.text } },
  { text: "RESTful API：HTTP 方法对应 CRUD 操作", options: { bullet: true, breakLine: true, fontSize: 12, color: C.text } },
  { text: "统一响应：ResultUtil 规范前后端交互格式", options: { bullet: true, breakLine: true, fontSize: 12, color: C.text } },
  { text: "安全设计：PreparedStatement 防注入、MD5 加密、Session 鉴权", options: { bullet: true, fontSize: 12, color: C.text } }
];
s25.addText(core25, { x: 0.7, y: 2.3, w: 3.8, h: 2.6, fontFace: "Arial" });
s25.addShape(pres.shapes.RECTANGLE, { x: 5.3, y: 1.7, w: 4.2, h: 3.4, fill: { color: C.cream } });
s25.addText("可扩展方向", { x: 5.5, y: 1.85, w: 3.8, h: 0.4, fontSize: 18, bold: true, color: C.berry, fontFace: "Arial" });
let ext25 = [
  { text: "引入数据库连接池（Druid / HikariCP）", options: { bullet: true, breakLine: true, fontSize: 12, color: C.text } },
  { text: "升级为 Spring + SpringMVC + MyBatis", options: { bullet: true, breakLine: true, fontSize: 12, color: C.text } },
  { text: "前端改用 Vue / React 实现前后端完全分离", options: { bullet: true, breakLine: true, fontSize: 12, color: C.text } },
  { text: "引入 Redis 缓存热点商品数据", options: { bullet: true, breakLine: true, fontSize: 12, color: C.text } },
  { text: "接入支付宝/微信支付 SDK 替换模拟支付", options: { bullet: true, breakLine: true, fontSize: 12, color: C.text } },
  { text: "增加 JWT Token 鉴权，支持多端登录", options: { bullet: true, fontSize: 12, color: C.text } }
];
s25.addText(ext25, { x: 5.5, y: 2.3, w: 3.8, h: 2.6, fontFace: "Arial" });

// Write file
pres.writeFile({ fileName: "d:/Java/personal/蛋糕商城项目演示_灰色主题.pptx" })
  .then(() => console.log("PPT generated successfully!"))
  .catch(err => console.error(err));
