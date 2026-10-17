-- FoodPick 校园美食推荐平台数据库结构
-- 目标数据库：MySQL 8.0+；字符集 utf8mb4
-- 说明：本脚本按原型功能设计，执行前请先创建/选择数据库。
-- 密码字段只存储安全哈希，不存明文密码。

CREATE TABLE users (
  user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户主键',
  username VARCHAR(32) NOT NULL COMMENT '登录用户名',
  password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
  email VARCHAR(254) NOT NULL COMMENT '邮箱',
  nickname VARCHAR(50) NOT NULL COMMENT '用户昵称',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  UNIQUE KEY uk_users_username (username),
  UNIQUE KEY uk_users_email (email),
  KEY idx_users_nickname (nickname)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户';

CREATE TABLE restaurants (
  restaurant_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '餐厅主键',
  name VARCHAR(120) NOT NULL COMMENT '餐厅名称',
  address VARCHAR(255) NOT NULL COMMENT '详细地址',
  phone VARCHAR(30) NULL COMMENT '联系电话',
  opening_hours VARCHAR(120) NULL COMMENT '营业时间描述',
  average_spend DECIMAL(8,2) NULL COMMENT '人均消费',
  cover_image_url VARCHAR(500) NULL COMMENT '餐厅封面图URL',
  description TEXT NULL COMMENT '餐厅简介',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '1营业/展示，0下架',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (restaurant_id),
  KEY idx_restaurants_name (name),
  KEY idx_restaurants_status_name (status, name),
  KEY idx_restaurants_average_spend (average_spend)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='餐厅';

CREATE TABLE dishes (
  dish_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '菜品主键',
  restaurant_id BIGINT UNSIGNED NOT NULL COMMENT '所属餐厅',
  name VARCHAR(120) NOT NULL COMMENT '菜品名称',
  category VARCHAR(60) NULL COMMENT '菜品分类/菜系',
  price DECIMAL(8,2) NOT NULL COMMENT '菜品价格',
  description TEXT NULL COMMENT '菜品描述',
  image_url VARCHAR(500) NULL COMMENT '菜品图片URL',
  is_available TINYINT NOT NULL DEFAULT 1 COMMENT '1可推荐，0停售',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (dish_id),
  CONSTRAINT fk_dishes_restaurant FOREIGN KEY (restaurant_id)
    REFERENCES restaurants (restaurant_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  KEY idx_dishes_restaurant (restaurant_id),
  KEY idx_dishes_name (name),
  KEY idx_dishes_category_price (category, price),
  KEY idx_dishes_available_price (is_available, price)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜品';

CREATE TABLE reviews (
  review_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '评价主键',
  user_id BIGINT UNSIGNED NOT NULL COMMENT '评价用户',
  restaurant_id BIGINT UNSIGNED NOT NULL COMMENT '被评价餐厅',
  rating TINYINT UNSIGNED NOT NULL COMMENT '评分1-5',
  content VARCHAR(1000) NULL COMMENT '评价内容',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (review_id),
  CONSTRAINT fk_reviews_user FOREIGN KEY (user_id)
    REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_reviews_restaurant FOREIGN KEY (restaurant_id)
    REFERENCES restaurants (restaurant_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5),
  KEY idx_reviews_restaurant_created (restaurant_id, created_at),
  KEY idx_reviews_user_created (user_id, created_at),
  KEY idx_reviews_restaurant_rating (restaurant_id, rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='餐厅评价';

CREATE TABLE restaurant_favorites (
  favorite_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '收藏主键',
  user_id BIGINT UNSIGNED NOT NULL,
  restaurant_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (favorite_id),
  CONSTRAINT fk_rf_user FOREIGN KEY (user_id)
    REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_rf_restaurant FOREIGN KEY (restaurant_id)
    REFERENCES restaurants (restaurant_id) ON UPDATE CASCADE ON DELETE CASCADE,
  UNIQUE KEY uk_rf_user_restaurant (user_id, restaurant_id),
  KEY idx_rf_restaurant (restaurant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='餐厅收藏';

CREATE TABLE dish_favorites (
  favorite_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '收藏主键',
  user_id BIGINT UNSIGNED NOT NULL,
  dish_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (favorite_id),
  CONSTRAINT fk_df_user FOREIGN KEY (user_id)
    REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_df_dish FOREIGN KEY (dish_id)
    REFERENCES dishes (dish_id) ON UPDATE CASCADE ON DELETE CASCADE,
  UNIQUE KEY uk_df_user_dish (user_id, dish_id),
  KEY idx_df_dish (dish_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜品收藏';

CREATE TABLE user_preferences (
  preference_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '偏好主键',
  user_id BIGINT UNSIGNED NOT NULL,
  taste_preference VARCHAR(255) NULL COMMENT '口味偏好，如麻辣、清淡',
  cuisine_preference VARCHAR(255) NULL COMMENT '菜系偏好',
  budget_max DECIMAL(8,2) NULL COMMENT '单餐预算上限',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (preference_id),
  CONSTRAINT fk_preferences_user FOREIGN KEY (user_id)
    REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE CASCADE,
  UNIQUE KEY uk_preferences_user (user_id),
  KEY idx_preferences_budget (budget_max)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户口味与预算偏好';

-- 设计说明：
-- 1. 首页/详情页的餐厅、菜品图片以 URL 保存；图片文件建议放对象存储或静态资源目录。
-- 2. 餐厅平均评分可通过 reviews 聚合计算，初版不冗余保存，避免数据不一致。
-- 3. 个性化推荐结果初版可实时按偏好、预算、评分计算，不强制建立推荐结果表。
-- 4. 搜索若升级为大规模模糊搜索，可评估 FULLTEXT 索引；普通 B-tree 索引不保证加速前置通配符 LIKE '%词%'。
