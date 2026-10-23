-- 蛋糕商城数据库初始化脚本

-- 创建数据库
CREATE DATABASE IF NOT EXISTS cakeshop DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE cakeshop;

-- 1. 用户表
CREATE TABLE IF NOT EXISTS `user` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  `password` VARCHAR(100) NOT NULL COMMENT '密码(MD5加密)',
  `email` VARCHAR(100) COMMENT '邮箱',
  `phone` VARCHAR(20) COMMENT '手机号',
  `avatar` VARCHAR(200) DEFAULT '/static/images/default-avatar.png' COMMENT '头像URL',
  `status` TINYINT DEFAULT 1 COMMENT '状态(0禁用/1正常)',
  `role` TINYINT DEFAULT 0 COMMENT '角色(0普通用户/1管理员)',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX `idx_username` (`username`),
  INDEX `idx_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 2. 商品分类表
CREATE TABLE IF NOT EXISTS `category` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
  `parent_id` INT DEFAULT 0 COMMENT '父分类ID(0为顶级分类)',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `status` TINYINT DEFAULT 1 COMMENT '状态(0禁用/1正常)',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  INDEX `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- 3. 商品表
CREATE TABLE IF NOT EXISTS `product` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT '商品名称',
  `category_id` INT NOT NULL COMMENT '分类ID',
  `price` DECIMAL(10,2) NOT NULL COMMENT '价格',
  `original_price` DECIMAL(10,2) COMMENT '原价',
  `stock` INT DEFAULT 0 COMMENT '库存',
  `sales` INT DEFAULT 0 COMMENT '销量',
  `image` VARCHAR(200) COMMENT '主图URL',
  `images` TEXT COMMENT '图片列表(JSON)',
  `description` VARCHAR(500) COMMENT '描述',
  `detail` TEXT COMMENT '详情(HTML)',
  `status` TINYINT DEFAULT 1 COMMENT '状态(0下架/1上架)',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX `idx_category_id` (`category_id`),
  INDEX `idx_status` (`status`),
  FOREIGN KEY (`category_id`) REFERENCES `category`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 4. 商品规格表
CREATE TABLE IF NOT EXISTS `product_spec` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `product_id` INT NOT NULL COMMENT '商品ID',
  `spec_name` VARCHAR(50) NOT NULL COMMENT '规格名称(尺寸/口味)',
  `spec_value` VARCHAR(100) NOT NULL COMMENT '规格值',
  `price` DECIMAL(10,2) NOT NULL COMMENT '价格',
  `stock` INT DEFAULT 0 COMMENT '库存',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  INDEX `idx_product_id` (`product_id`),
  FOREIGN KEY (`product_id`) REFERENCES `product`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品规格表';

-- 5. 购物车表
CREATE TABLE IF NOT EXISTS `cart` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `user_id` INT NOT NULL COMMENT '用户ID',
  `product_id` INT NOT NULL COMMENT '商品ID',
  `spec_id` INT COMMENT '规格ID',
  `quantity` INT DEFAULT 1 COMMENT '数量',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX `idx_user_id` (`user_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
  FOREIGN KEY (`product_id`) REFERENCES `product`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- 6. 订单表
CREATE TABLE IF NOT EXISTS `order` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `order_no` VARCHAR(50) NOT NULL UNIQUE COMMENT '订单号',
  `user_id` INT NOT NULL COMMENT '用户ID',
  `total_amount` DECIMAL(10,2) NOT NULL COMMENT '总金额',
  `pay_amount` DECIMAL(10,2) NOT NULL COMMENT '实付金额',
  `coupon_id` INT COMMENT '优惠券ID',
  `discount_amount` DECIMAL(10,2) DEFAULT 0 COMMENT '优惠金额',
  `status` TINYINT DEFAULT 0 COMMENT '状态(0待付款/1待发货/2待收货/3已完成/4已取消)',
  `receiver_name` VARCHAR(50) NOT NULL COMMENT '收货人',
  `receiver_phone` VARCHAR(20) NOT NULL COMMENT '收货电话',
  `receiver_address` VARCHAR(200) NOT NULL COMMENT '收货地址',
  `delivery_time` VARCHAR(50) COMMENT '配送时间',
  `remark` VARCHAR(200) COMMENT '备注',
  `pay_time` DATETIME COMMENT '支付时间',
  `ship_time` DATETIME COMMENT '发货时间',
  `receive_time` DATETIME COMMENT '收货时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_order_no` (`order_no`),
  INDEX `idx_status` (`status`),
  FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 7. 订单明细表
CREATE TABLE IF NOT EXISTS `order_item` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `order_id` INT NOT NULL COMMENT '订单ID',
  `product_id` INT NOT NULL COMMENT '商品ID',
  `product_name` VARCHAR(100) NOT NULL COMMENT '商品名称',
  `product_image` VARCHAR(200) COMMENT '商品图片',
  `spec_id` INT DEFAULT NULL COMMENT '规格ID，无规格为 NULL',
  `spec_name` VARCHAR(50) COMMENT '规格名称',
  `price` DECIMAL(10,2) NOT NULL COMMENT '单价',
  `quantity` INT NOT NULL COMMENT '数量',
  `total_price` DECIMAL(10,2) NOT NULL COMMENT '小计',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  INDEX `idx_order_id` (`order_id`),
  FOREIGN KEY (`order_id`) REFERENCES `order`(`id`),
  FOREIGN KEY (`product_id`) REFERENCES `product`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细表';

-- 8. 收货地址表
CREATE TABLE IF NOT EXISTS `address` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `user_id` INT NOT NULL COMMENT '用户ID',
  `receiver_name` VARCHAR(50) NOT NULL COMMENT '收货人',
  `receiver_phone` VARCHAR(20) NOT NULL COMMENT '收货电话',
  `province` VARCHAR(50) NOT NULL COMMENT '省',
  `city` VARCHAR(50) NOT NULL COMMENT '市',
  `district` VARCHAR(50) NOT NULL COMMENT '区',
  `detail_address` VARCHAR(200) NOT NULL COMMENT '详细地址',
  `is_default` TINYINT DEFAULT 0 COMMENT '是否默认(0否/1是)',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX `idx_user_id` (`user_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收货地址表';

-- 9. 评价表
CREATE TABLE IF NOT EXISTS `review` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `user_id` INT NOT NULL COMMENT '用户ID',
  `product_id` INT NOT NULL COMMENT '商品ID',
  `order_id` INT NOT NULL COMMENT '订单ID',
  `rating` TINYINT NOT NULL COMMENT '评分(1-5)',
  `content` TEXT COMMENT '评价内容',
  `images` TEXT COMMENT '评价图片(JSON)',
  `status` TINYINT DEFAULT 1 COMMENT '状态(0隐藏/1显示)',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_product_id` (`product_id`),
  INDEX `idx_order_id` (`order_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
  FOREIGN KEY (`product_id`) REFERENCES `product`(`id`),
  FOREIGN KEY (`order_id`) REFERENCES `order`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评价表';

-- 10. 优惠券表
CREATE TABLE IF NOT EXISTS `coupon` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT '优惠券名称',
  `type` TINYINT NOT NULL COMMENT '类型(1满减/2折扣)',
  `min_amount` DECIMAL(10,2) NOT NULL COMMENT '最低消费金额',
  `discount` DECIMAL(10,2) NOT NULL COMMENT '优惠金额/折扣率(如8折)',
  `start_time` DATETIME NOT NULL COMMENT '开始时间',
  `end_time` DATETIME NOT NULL COMMENT '结束时间',
  `total` INT NOT NULL COMMENT '发放数量',
  `used` INT DEFAULT 0 COMMENT '已使用数量',
  `status` TINYINT DEFAULT 1 COMMENT '状态(0禁用/1正常)',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券表';

-- 11. 用户优惠券表
CREATE TABLE IF NOT EXISTS `user_coupon` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `user_id` INT NOT NULL COMMENT '用户ID',
  `coupon_id` INT NOT NULL COMMENT '优惠券ID',
  `status` TINYINT DEFAULT 0 COMMENT '状态(0未使用/1已使用/2已过期)',
  `get_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '领取时间',
  `use_time` DATETIME COMMENT '使用时间',
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_coupon_id` (`coupon_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
  FOREIGN KEY (`coupon_id`) REFERENCES `coupon`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

-- 插入测试数据

-- 管理员账号 (密码: admin123, MD5加密)
INSERT IGNORE INTO `user` (`username`, `password`, `email`, `phone`, `status`, `role`) VALUES
('admin', '0192023a7bbd73250516f069df18b500', 'admin@cakeshop.com', '13800138000', 1, 1);

-- 测试用户 (密码: 123456, MD5加密)
INSERT IGNORE INTO `user` (`username`, `password`, `email`, `phone`, `status`) VALUES
('testuser', 'e10adc3949ba59abbe56e057f20f883e', 'test@example.com', '13900139000', 1);

-- 商品分类
INSERT IGNORE INTO `category` (`name`, `parent_id`, `sort_order`) VALUES
('生日蛋糕', 0, 1),
('婚礼蛋糕', 0, 2),
('下午茶蛋糕', 0, 3),
('节日蛋糕', 0, 4),
('儿童蛋糕', 0, 5);

-- 子分类
INSERT IGNORE INTO `category` (`name`, `parent_id`, `sort_order`) VALUES
('水果蛋糕', 1, 1),
('巧克力蛋糕', 1, 2),
('奶油蛋糕', 1, 3),
('慕斯蛋糕', 1, 4),
('翻糖蛋糕', 2, 1),
('多层蛋糕', 2, 2),
('纸杯蛋糕', 3, 1),
('芝士蛋糕', 3, 2),
('提拉米苏', 3, 3),
('圣诞蛋糕', 4, 1),
('新年蛋糕', 4, 2),
('卡通蛋糕', 5, 1),
('动物蛋糕', 5, 2);

-- 示例商品
INSERT IGNORE INTO `product` (`name`, `category_id`, `price`, `original_price`, `stock`, `image`, `description`, `status`) VALUES
('经典水果生日蛋糕', 6, 128.00, 168.00, 100, '/static/images/cake1.jpg', '新鲜水果搭配轻盈奶油，经典口味', 1),
('浓郁巧克力蛋糕', 7, 158.00, 198.00, 80, '/static/images/cake2.jpg', '进口比利时巧克力，口感浓郁', 1),
('草莓奶油蛋糕', 8, 108.00, 138.00, 120, '/static/images/cake3.jpg', '新鲜草莓搭配香草奶油', 1),
('芒果慕斯蛋糕', 9, 138.00, 168.00, 90, '/static/images/cake4.jpg', '细腻慕斯口感，芒果香气浓郁', 1),
('婚礼多层蛋糕', 11, 588.00, 688.00, 50, '/static/images/cake5.jpg', '精美翻糖装饰，三层婚礼蛋糕', 1),
('下午茶纸杯蛋糕', 12, 68.00, 88.00, 200, '/static/images/cake6.jpg', '6个装，多种口味可选', 1),
('经典芝士蛋糕', 13, 88.00, 108.00, 150, '/static/images/cake7.jpg', '浓郁芝士，入口即化', 1),
('圣诞主题蛋糕', 15, 188.00, 228.00, 60, '/static/images/cake8.jpg', '圣诞限定款，节日氛围满满', 1),
('卡通儿童蛋糕', 17, 148.00, 178.00, 70, '/static/images/cake9.jpg', '可爱卡通造型，孩子最爱', 1),
('提拉米苏蛋糕', 14, 118.00, 148.00, 100, '/static/images/cake10.jpg', '意式经典，咖啡香醇', 1);

-- 商品规格
INSERT IGNORE INTO `product_spec` (`product_id`, `spec_name`, `spec_value`, `price`, `stock`) VALUES
(1, '尺寸', '6寸', 128.00, 50),
(1, '尺寸', '8寸', 168.00, 30),
(1, '尺寸', '10寸', 208.00, 20),
(2, '尺寸', '6寸', 158.00, 40),
(2, '尺寸', '8寸', 198.00, 25),
(2, '尺寸', '10寸', 248.00, 15),
(2, '口味', '黑巧克力', 158.00, 40),
(2, '口味', '白巧克力', 148.00, 40);

-- 优惠券
INSERT IGNORE INTO `coupon` (`name`, `type`, `min_amount`, `discount`, `start_time`, `end_time`, `total`) VALUES
('新人优惠券', 1, 100.00, 20.00, '2024-01-01', '2025-12-31', 1000),
('满200减50', 1, 200.00, 50.00, '2024-01-01', '2025-12-31', 500),
('8折优惠券', 2, 150.00, 0.8, '2024-01-01', '2025-12-31', 300);

-- 增量更新：为已有数据库添加role字段
-- ALTER TABLE `user` ADD COLUMN `role` TINYINT DEFAULT 0 COMMENT '角色(0普通用户/1管理员)' AFTER `status`;
-- UPDATE `user` SET `role` = 1 WHERE `username` = 'admin';
