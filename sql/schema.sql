-- ============================================================
-- Olist 电商数据集 建表脚本
-- 数据来源：Kaggle - Brazilian E-Commerce Public Dataset by Olist
-- 说明：原始数据中部分日期字段存在 0000-00-00 等非法值，
--       为兼容 MySQL 严格模式，相关字段采用 VARCHAR 存储，
--       分析时按需用 STR_TO_DATE() 转换。
-- ============================================================

-- 1. 客户表
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- 2. 地理位置表（数据量大、无唯一主键，仅加索引）
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(11,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2),
    INDEX idx_zip (geolocation_zip_code_prefix)
);

-- 3. 订单表
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp VARCHAR(30),
    order_approved_at VARCHAR(30),
    order_delivered_carrier_date VARCHAR(30),
    order_delivered_customer_date VARCHAR(30),
    order_estimated_delivery_date VARCHAR(30),
    INDEX idx_customer (customer_id),
    INDEX idx_purchase (order_purchase_timestamp)
);

-- 4. 订单明细表（复合主键：一个订单可包含多件商品）
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date VARCHAR(30),
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),
    INDEX idx_product (product_id)
);

-- 5. 支付表
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

-- 6. 评价表
CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(200),
    review_comment_message TEXT,
    review_creation_date VARCHAR(30),
    review_answer_timestamp VARCHAR(30),
    INDEX idx_order (order_id)
);

-- 7. 商品表（注意：原始字段名拼写为 lenght，保持原样以匹配 CSV）
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- 8. 卖家表
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

-- 9. 品类翻译表（葡萄牙语 → 英语）
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);