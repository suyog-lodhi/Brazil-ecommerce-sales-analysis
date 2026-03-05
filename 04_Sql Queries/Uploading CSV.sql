
-- This file consist of SQL queries which include CSV file uploading in MYSQL WORKBENCH.

create database ecommerce;
use ecommerce;


-- uploading geolocation table 

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(4)
);

desc geolocation;

ALTER TABLE geolocation
ADD CONSTRAINT pkk_01
PRIMARY KEY (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng); 



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/geolocation.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from geolocation;
select count(*) from geolocation;


-- ****************************************************************************************



-- uploading customers table

CREATE TABLE customers_1 (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

describe customers_1;

ALTER TABLE customers_1
ADD CONSTRAINT primary_key
PRIMARY KEY (customer_id);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers_1.csv'
INTO TABLE customers_1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select * from customers_1;
select count(*) from customers_1;


-- ****************************************************************************************



-- uploading orders_items table

CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);


describe order_items;

ALTER TABLE order_items
ADD CONSTRAINT primary_key
PRIMARY KEY (order_id, order_item_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_key
FOREIGN KEY (product_id) references products(product_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_key_2
FOREIGN KEY (seller_id) references sellers(seller_id);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select * from order_items;
select count(*) from order_items;


-- ****************************************************************************************



-- uploading order_payments table

CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

describe order_payments;

ALTER TABLE order_payments
ADD CONSTRAINT FK2
FOREIGN KEY (order_id) references orders(order_id);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_payments.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select * from order_payments;
select count(*) from order_payments;


-- ****************************************************************************************




-- uploading table order_reviews



CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

describe order_reviews;

ALTER TABLE order_reviews
ADD constraint PKK
PRIMARY KEY (review_id, order_id);


ALTER TABLE order_reviews
ADD CONSTRAINT FKKK
FOREIGN KEY (order_id) REFERENCES orders(order_id);



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_reviews1.csv'
INTO TABLE order_reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id,
 order_id,
 review_score,
 review_comment_title,
 review_comment_message,
 @review_creation_date,
 @review_answer_timestamp)
SET
review_creation_date =
    CASE
        WHEN @review_creation_date LIKE '%/%'
        THEN STR_TO_DATE(@review_creation_date, '%m/%d/%Y %H:%i')
        ELSE STR_TO_DATE(@review_creation_date, '%Y-%m-%d %H:%i:%s')
    END,

review_answer_timestamp =
    CASE
        WHEN @review_answer_timestamp LIKE '%/%'
        THEN STR_TO_DATE(@review_answer_timestamp, '%m/%d/%Y %H:%i')
        ELSE STR_TO_DATE(@review_answer_timestamp, '%Y-%m-%d %H:%i:%s')
    END;

select * from order_reviews;
select count(*) from order_reviews;


-- ****************************************************************************************


-- uploading table orders

CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

describe orders;

ALTER TABLE orders
ADD CONSTRAINT pk
PRIMARY KEY (order_id);

ALTER TABLE orders
ADD CONSTRAINT fk
FOREIGN KEY (customer_id) references customers_1(customer_id);

drop table orders;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

(
order_id,
customer_id,
order_status,
@order_purchase_timestamp,
@order_approved_at,
@order_delivered_carrier_date,
@order_delivered_customer_date,
@order_estimated_delivery_date
)

SET
order_purchase_timestamp = NULLIF(TRIM(@order_purchase_timestamp),''),
order_approved_at = NULLIF(TRIM(@order_approved_at),''),
order_delivered_carrier_date = NULLIF(TRIM(@order_delivered_carrier_date),''),
order_delivered_customer_date = NULLIF(TRIM(@order_delivered_customer_date),''),
order_estimated_delivery_date = NULLIF(TRIM(@order_estimated_delivery_date),'');


-- ****************************************************************************************


-- uploading product category name translation file

CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);


ALTER TABLE product_category_translation
ADD PRIMARY KEY (product_category_name);





desc product_category_translation;
select * from product_category_translation;
select count(*) from product_category_translation;



 -- ***************************************************************************************************

-- uploading products file


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS

(
product_id,
@product_category_name,
@product_name_lenght,
@product_description_lenght,
@product_photos_qty,
@product_weight_g,
@product_length_cm,
@product_height_cm,
@product_width_cm
)

SET
product_category_name      = NULLIF(TRIM(@product_category_name),''),
product_name_lenght        = NULLIF(TRIM(@product_name_lenght),''),
product_description_lenght = NULLIF(TRIM(@product_description_lenght),''),
product_photos_qty         = NULLIF(TRIM(@product_photos_qty),''),
product_weight_g           = NULLIF(TRIM(@product_weight_g),''),
product_length_cm          = NULLIF(TRIM(@product_length_cm),''),
product_height_cm          = NULLIF(TRIM(@product_height_cm),''),
product_width_cm           = NULLIF(TRIM(@product_width_cm),'');


select * from products;
select count(*) from products;


desc products;

ALTER TABLE products
ADD CONSTRAINT fk_category
FOREIGN KEY (product_category_name)
REFERENCES product_category_translation(product_category_name);





SELECT DISTINCT product_category_name
FROM products
WHERE product_category_name NOT IN (
    SELECT product_category_name
    FROM product_category_translation
);

INSERT INTO product_category_translation 
(product_category_name, product_category_name_english)
VALUES 
('pc_gamer', 'pc_gamer'),
('portateis_cozinha_e_preparadores_de_alimentos', 'portable_kitchen_appliances');


-- ****************************************************************************************



-- uploading sellers file

CREATE TABLE sellers (
    seller_id CHAR(32) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sellers.csv'
INTO TABLE sellers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
seller_id,
@seller_zip_code_prefix,
@seller_city,
@seller_state
)

SET
seller_zip_code_prefix = NULLIF(TRIM(@seller_zip_code_prefix),''),
seller_city            = NULLIF(TRIM(@seller_city),''),
seller_state           = NULLIF(TRIM(@seller_state),'')
;