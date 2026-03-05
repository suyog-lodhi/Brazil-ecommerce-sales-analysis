

-- Preliminary Exploration, Data Cleaning,Checking Duplicates and Blanks in each file 


-- 1. ***********************************   orders table  ****************************************
    
    SELECT * FROM orders; -- all 8 colms are imported 
    
    SELECT COUNT(*) FROM orders; -- all 99441 rows imported 
    
	SELECT order_id, COUNT(*) FROM ORDERS
    GROUP BY order_id
    HAVING COUNT(*) > 1 ; -- No duplicate result
    
    SELECT * FROM orders
    WHERE order_id IS NULL; -- No blank order_id

    SELECT *
	FROM orders
	WHERE order_delivered_customer_date < order_purchase_timestamp; -- No delivery date is before purchase date


    SELECT DISTINCT order_status FROM orders;
    
    SELECT order_status, COUNT(*) AS Counts FROM orders
	GROUP BY order_status
	ORDER BY Counts DESC ;
    
    -- CHECKING THE DELIVERED ORDERS CONSISTENCY 
    
	SELECT * FROM orders
    WHERE order_delivered_customer_date IS NULL AND order_status = 'delivered'; -- 8 rows , order is delivered but delivery date is missing


	SELECT * FROM orders
    WHERE order_purchase_timestamp IS NULL AND order_status = 'delivered'; -- 0 rows returned

	SELECT * FROM orders
    WHERE order_approved_at IS NULL AND order_status = 'delivered'; -- 14 rows returned
    
    SELECT * FROM orders
    WHERE order_delivered_carrier_date IS NULL AND order_status = 'delivered'; -- 2 rows returned
    
     SELECT * FROM orders
    WHERE order_estimated_delivery_date IS NULL AND order_status = 'delivered'; -- 0 rows returned

  
/*  conclusion is those 8 rows and 14 rows are example of inconsitent data since compared to dataset
22 rows are very less so we can neglect them but we should use filter while running other queries  */


-- CHECKING ORDER STATUS CREATED CONSISTENCY


SELECT * FROM orders
WHERE order_status = 'created'; -- 5 rows returned

	SELECT * FROM orders
    WHERE order_delivered_customer_date IS NULL AND order_status = 'created'; -- 5 rows , correct


	SELECT * FROM orders
    WHERE order_purchase_timestamp IS NULL AND order_status = 'created'; -- 0 rows returned, correct

	SELECT * FROM orders
    WHERE order_approved_at IS NULL AND order_status = 'created'; -- 5 rows returned, correct
    
    SELECT * FROM orders
    WHERE order_delivered_carrier_date IS NULL AND order_status = 'created'; -- 5 rows returned, correct
    
	SELECT * FROM orders
    WHERE order_estimated_delivery_date IS NOT NULL AND order_status = 'created'; -- 5 rows returned , correct



-- CHECKING ORDER STATUS APPROVED CONSISTENCY


SELECT * FROM orders
WHERE order_status = 'approved'; -- 2 rows returned

	SELECT * FROM orders
    WHERE order_delivered_customer_date IS NULL AND order_status = 'approved'; -- 2 rows , correct


	SELECT * FROM orders
    WHERE order_purchase_timestamp IS NULL AND order_status = 'approved'; -- 0 rows returned, correct

	SELECT * FROM orders
    WHERE order_approved_at IS NULL AND order_status = 'approved'; -- 0 rows returned, correct
    
    SELECT * FROM orders
    WHERE order_delivered_carrier_date IS NOT NULL AND order_status = 'approved'; -- 0 rows returned, correct
    
	SELECT * FROM orders
    WHERE order_estimated_delivery_date IS NOT NULL AND order_status = 'approved'; -- 2 rows returned , correct



-- CHECKING ORDER STATUS shipped CONSISTENCY

SELECT COUNT(*) FROM orders
WHERE order_status = 'shipped'; -- 1107 rows returned

SELECT * FROM orders
WHERE order_status = 'shipped'; 

	SELECT count(*) FROM orders
    WHERE order_delivered_customer_date IS NULL AND order_status = 'shipped'; -- 1107 rows , correct


	SELECT * FROM orders
    WHERE order_purchase_timestamp IS NULL AND order_status = 'shipped'; -- 0 rows returned, correct

	SELECT * FROM orders
    WHERE order_approved_at IS NULL AND order_status = 'shipped'; -- 0 rows returned, correct
    
    SELECT * FROM orders
    WHERE order_delivered_carrier_date IS  NULL AND order_status = 'shipped'; -- 0 rows returned, correct
    
	SELECT * FROM orders
    WHERE order_estimated_delivery_date IS  NULL AND order_status = 'shipped'; -- 0 rows returned , correct


-- CHECKING ORDER STATUS canceled CONSISTENCY

SELECT COUNT(*) FROM orders
WHERE order_status = 'canceled'; -- 625 rows returned

SELECT * FROM orders
WHERE order_status = 'canceled'; 

	SELECT count(*) FROM orders
    WHERE order_delivered_customer_date IS NOT NULL AND order_status = 'canceled'; -- 6 rows , correct


	SELECT * FROM orders
    WHERE order_purchase_timestamp IS NULL AND order_status = 'canceled'; -- 0 rows returned, correct

	SELECT * FROM orders
    WHERE order_approved_at IS NOT NULL AND order_status = 'canceled'; -- 484 rows returned
    
    SELECT COUNT(*) FROM orders
    WHERE order_delivered_carrier_date IS NULL AND order_status = 'canceled'; -- 550 rows returned
    
	SELECT * FROM orders
    WHERE order_estimated_delivery_date IS  NULL AND order_status = 'canceled'; -- 0 rows returned , correct


-- CHECKING ORDER STATUS UNAVAILABLE CONSISTENCY

SELECT COUNT(*) FROM orders
WHERE order_status = 'unavailable'; -- 609 rows returned

SELECT * FROM orders
WHERE order_status = 'unavailable'; 

	SELECT count(*) FROM orders
    WHERE order_delivered_customer_date IS NOT NULL AND order_status = 'unavailable'; -- 0 rows , correct


	SELECT * FROM orders
    WHERE order_purchase_timestamp IS NULL AND order_status = 'unavailable'; -- 0 rows returned, correct

	SELECT * FROM orders
    WHERE order_approved_at IS NULL AND order_status = 'unavailable'; -- 0 rows returned
    
    SELECT COUNT(*) FROM orders
    WHERE order_delivered_carrier_date IS NOT NULL AND order_status = 'unavailable'; -- 0 rows returned
    
	SELECT * FROM orders
    WHERE order_estimated_delivery_date IS  NULL AND order_status = 'unavailable'; -- 0 rows returned , correct





-- 2. ***********************************   customers_1 table  ****************************************

SELECT * FROM customers_1 ; -- 5 colms returned

SELECT COUNT(*) FROM customers_1 ; -- 99441 

DESC customers_1 ; -- customer id primary key


SELECT COUNT(*) FROM customers_1 
WHERE customer_id IS NULL OR  customer_unique_id IS NULL OR customer_zip_code_prefix IS NULL OR customer_city IS NULL OR customer_state  IS NULL ; -- 0 ROWS RETURNED


SELECT COUNT(*) FROM customers_1
GROUP BY customer_id 
HAVING COUNT(*)> 1 ; -- 0 ROWS RETURNED, CORRECT


SELECT COUNT(*) FROM customers_1
GROUP BY customer_unique_id 
HAVING COUNT(*)> 1 ; -- MORE THAN 500 RETURNED , CORRECT


SELECT  COUNT(DISTINCT customer_unique_id) FROM customers_1; -- 96096
-- 99,441 - 96,096 = 3,345 repeat customer records

select count(customer_id) from customers_1; 

-- conclusion = no null values, no duplicates , all rows inserted, data cleaned

                      -- cleaning customer_city colm 
                      
SELECT customer_city
FROM customers_1
WHERE customer_city REGEXP '[^a-z0-9 ''().,-]'; -- returned zero rows , ok , we were checking that whether the city names has signs or special characters etc


-- 3. ***********************************   order_items table  ****************************************

SELECT * FROM order_items ; -- 7 columns returned

SELECT COUNT(*) FROM order_items; -- 112650 rows returned

DESC order_items; -- primary key (order_id, order_item_id), foreign key - product id, seller_id

SELECT * FROM order_items 
WHERE
	order_id IS NULL OR order_item_id IS NULL OR product_id IS NULL OR 
	seller_id IS NULL OR shipping_limit_date IS NULL OR price IS NULL OR  freight_value IS NULL ; -- 0 ROWS RETURNED



SELECT order_id, order_item_id, COUNT(*) FROM order_items
GROUP BY order_Id, order_item_id
HAVING COUNT(*) > 1 ; -- 0 rows correct our pk working fine


SELECT order_id, COUNT(*) FROM order_items
GROUP BY order_Id
HAVING COUNT(*) > 1 ; -- more than 500 rows returned , expected

SELECT  product_id, COUNT(*) FROM order_items
GROUP BY product_id
HAVING COUNT(*) > 1 ; -- more than 500 rows returned , expected

-- conclusion : no duplicates, no null values , okay 


-- 4. ***********************************   products table  ****************************************


SELECT * FROM products; -- 9 colms returned correct

SELECT COUNT(*) FROM products ; -- 32951 rows returned, correct

SELECT * FROM products
WHERE
product_id IS NULL OR	product_category_name IS NULL ; -- 610 rows returned

UPDATE products
SET product_category_name = 'unknown'
WHERE product_category_name IS NULL;



SELECT * FROM products
WHERE
	product_id IS NULL OR	
	product_category_name IS NULL OR	
	product_name_lenght IS NULL OR	
	product_description_lenght IS NULL OR	
	product_photos_qty IS NULL OR	
	product_weight_g IS NULL OR	
	product_length_cm IS NULL OR 
	product_height_cm IS NULL OR 
	product_width_cm IS NULL ; 

-- RETURNED MORE THAN 500 ROWS 



-- we cannot delete the empty rows so we put them under category 'unknown' and created a VIEW

CREATE VIEW products_clean AS
SELECT
product_id,
IFNULL(product_category_name, 'unknown') AS product_category_name,
product_weight_g,
product_length_cm,
product_height_cm,
product_width_cm
FROM products;

select * from products_clean
where product_category_name = 'unknown'; -- 610 rows returned


-- 5. ***********************************   sellers table  ****************************************


SELECT * FROM sellers ; -- 4 COLM RETURNS

SELECT COUNT(*) FROM sellers ; -- 3095 rows returned

SELECT COUNT(*) FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1 ;  -- 0 Rows returned, no duplicate seller

SELECT * FROM sellers 
WHERE seller_id IS NULL OR	seller_zip_code_prefix	IS NULL OR seller_city	IS NULL OR seller_state IS NULL ;
-- 0 ROWS RETURNED , NO BLANKS

SELECT seller_state, COUNT(*) FROM sellers
GROUP BY seller_state
ORDER BY COUNT(*) DESC ; -- MOST SELLERS ARE FROM STATE SP (1849)


-- cleaning seller_city colm cause it has mixed names of city and state in a single colm , one email

SELECT seller_city
FROM sellers
WHERE seller_city REGEXP '[^a-z0-9 ''().,-]';

update sellers
set seller_city = 'ji parana'
where seller_city = 'ji-paraná';

set sql_safe_updates = 0;
SET SQL_SAFE_UPDATES = 1;
/*
ribeirao preto / sao paulo
sp / sp
santa barbara d´oeste
vendas@creditparts.com.br
santa barbara d´oeste
pinhais/pr
sao sebastiao da grama/sp
sao paulo / sao paulo
mogi das cruzes / sp
cariacica / es
jacarei / sao paulo
maua/sao paulo
carapicuiba / sao paulo
são paulo
auriflama/sp
sbc/sp
rio de janeiro 
io de janeiro
rio de janeiro / rio de janeiro
santo andre/sao paulo
barbacena/ minas gerais
ji-paraná
*/


UPDATE sellers
SET seller_city = TRIM(SUBSTRING_INDEX(seller_city, '/', 1))
WHERE seller_city LIKE '%/%'; -- removing parts after slash


SELECT * FROM sellers
WHERE seller_city LIKE '%@%'; -- email in the colm

UPDATE sellers
SET seller_city = NULL
WHERE seller_city LIKE '%@%';

UPDATE sellers
SET seller_city = REPLACE(seller_city, '´', '''')
WHERE seller_city LIKE '%´%';

UPDATE sellers
SET seller_city = 'sao paulo'
WHERE seller_city = 'são paulo';

UPDATE sellers
SET seller_city = 'sao paulo'
WHERE seller_city = 'sp';


UPDATE sellers
SET seller_city = 'rio de janeiro'
WHERE seller_city LIKE '%rio de janeiro%';

UPDATE sellers
SET seller_city = TRIM(SUBSTRING_INDEX(seller_city, '-', 1));

UPDATE sellers
SET seller_city = TRIM(
    REGEXP_REPLACE(seller_city, ' (sp|rj|mg|sc|rs|df|pr|ba)$', '')
);

SELECT seller_city
FROM sellers
WHERE seller_city REGEXP '^[0-9]+$';

update sellers 
set seller_city = null
where seller_city = '04482255';

UPDATE sellers
SET seller_city = 'porto seguro'
WHERE seller_city = 'arraial d''ajuda (porto seguro)';

UPDATE sellers
SET seller_city = 'sao bernardo do campo'
WHERE seller_city = 'sbc';



UPDATE sellers
SET seller_city = SUBSTRING_INDEX(seller_city, ',', 1)
WHERE seller_city LIKE '%,%';

UPDATE sellers
SET seller_city = REGEXP_REPLACE(seller_city, ' +', ' ');

UPDATE sellers
SET seller_city = 'ribeirao preto'
WHERE seller_city IN ('riberao preto','robeirao preto','ribeirao pretp');

UPDATE sellers
SET seller_city = 'sao paulo'
WHERE seller_city IN ('sao pauo','sao paulop','sao paluo');

UPDATE sellers
SET seller_city = 'mogi das cruzes'
WHERE seller_city = 'mogi das cruses';


-- 6. ***********************************   orders payment table  ****************************************


SELECT * FROM order_payments ; -- 5 colms returned

SELECT COUNT(*) FROM order_payments ; -- 1,03,886 rows returned

SELECT * FROM order_payments
	WHERE 	order_id	IS NULL OR payment_sequential IS NULL OR	payment_type IS NULL OR 	
			payment_installments IS NULL OR	payment_value IS NULL ; -- 0 ROWS RETURNED , NO BLANKS

SELECT order_id, COUNT(*) FROM order_payments
GROUP BY order_id 
HAVING COUNT(*) >1 ; -- RETURNED MORE THAN 500 ROWS

SELECT payment_type , COUNT(*) FROM order_payments
GROUP BY payment_type
ORDER BY COUNT(*) DESC; -- MOST PAYMENT DONE BY CREDIT CARDS

-- check is there any order with blank payment and also check is there any payments without orders

SELECT * FROM orders 
LEFT JOIN order_payments
ON orders.order_id = order_payments.order_id
WHERE order_payments.order_id IS NULL; -- 1 ROW RETURNED , ACCEPTABLE


SELECT p.order_id
FROM order_payments p
LEFT JOIN orders o
ON p.order_id = o.order_id
WHERE o.order_id IS NULL; -- 0 ROWS RETURNED




-- 7. ***********************************   order_reviews table  ****************************************

SELECT * FROM order_reviews; -- 7 columns returned
SELECT COUNT(*) FROM order_reviews; -- 99,222 rows returned

DESC order_reviews; -- (review_id + order_id) PK

SELECT review_id, COUNT(*) FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1 ; -- more than 500 rows , acceptable

SELECT order_id, COUNT(*) FROM order_reviews
GROUP BY order_id
HAVING COUNT(*) > 1 ; -- more than 500 rows , acceptable

SELECT review_id,order_id, COUNT(*) FROM order_reviews
GROUP BY review_id, order_id
HAVING COUNT(*) > 1 ; -- 0 rows returned , PK working fine

SELECT * FROM order_reviews
WHERE order_id  IS NULL OR review_id IS NULL ; -- 0 ROWS RETURNED

SELECT review_id , order_id FROM order_reviews
WHERE review_score IS NULL ; -- 0 ROWS RETURNED

SELECT * FROM order_reviews
WHERE review_comment_title = '' OR review_comment_message = ''; -- MORE THAN 500 ROWS RETURNED

-- CHECK THAT ALL ORDERS IN THE ORDER TABLE ARE REVIEWED OR SOME ARE NOT REVIEWED


SELECT orders.order_id FROM orders
LEFT JOIN order_reviews
ON orders.order_id = order_reviews.order_id
WHERE order_reviews.order_id IS NULL ; -- MORE THAN 500 ROWS RETURNED




-- 8. ***********************************   GEOLOCATION table  ****************************************

SELECT * FROM geolocation; -- 5 COLMS RETURNED

SELECT COUNT(*) FROM geolocation; -- 10,00,163 ROWS RETURNED


SELECT * FROM geolocation 
WHERE
geolocation_zip_code_prefix IS NULL OR	geolocation_lat IS NULL OR	
geolocation_lng IS NULL OR	geolocation_city IS NULL OR	geolocation_state IS NULL ; -- 0 ROWS RETURNED 


SELECT geolocation_zip_code_prefix , COUNT(*) FROM geolocation
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(*) >1 ; -- more than 500 rows returned


SELECT geolocation_lat , COUNT(*) FROM geolocation
GROUP BY geolocation_lat
HAVING COUNT(*) >1 ; -- MORE THAN 500 ROWS RETURNED

SELECT geolocation_lng , COUNT(*) FROM geolocation
GROUP BY geolocation_lng
HAVING COUNT(*) >1 ; -- MORE THAN 500 ROWS RETURNED

-- ---------------------------- cleaning of geolocation table's geolocation_city column (Used chatgpt)

select geolocation_city from geolocation;

UPDATE geolocation
SET geolocation_city =
  LOWER(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                REPLACE(
                  REPLACE(
                    REPLACE(
                      REPLACE(
                        geolocation_city,
                      'ã','a'),
                    'á','a'),
                  'â','a'),
                'à','a'),
              'é','e'),
            'ê','e'),
          'í','i'),
        'ó','o'),
      'ô','o'),
    'ç','c')
  )
WHERE geolocation_zip_code_prefix IS NOT NULL;


UPDATE geolocation
SET geolocation_city =
REPLACE(
REPLACE(
REPLACE(
geolocation_city,
'%26','&'),
'%27',"'"),
'%3b','')
WHERE geolocation_city LIKE '%\%%';

UPDATE geolocation
SET geolocation_city = REPLACE(geolocation_city,'£','a')
WHERE geolocation_city LIKE '%£%';

UPDATE geolocation
SET geolocation_city =
LOWER(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
geolocation_city,
'á','a'),'à','a'),'ã','a'),'â','a'),'ä','a'),
'é','e'),'ê','e'),
'í','i'),
'ó','o'),'ô','o')
);

UPDATE geolocation
SET geolocation_city = REPLACE(geolocation_city, 'ü', 'u')
WHERE geolocation_city LIKE '%ü%';

UPDATE geolocation
SET geolocation_city = 'cidade'
WHERE geolocation_city = '* cidade';

UPDATE geolocation
SET geolocation_city = 'quarto centenario'
WHERE geolocation_city = '4º centenario';

UPDATE geolocation
SET geolocation_city = 'sao joao do pau d\'alho'
WHERE geolocation_city = 'sao joao do pau d&aposalho';



SET SQL_SAFE_UPDATES = 1;


select geolocation_city, count(*) from geolocation
group by geolocation_city
order by count(*) desc ; -- 5979 rows returned 


UPDATE geolocation
SET geolocation_city = 'teresopolis'
WHERE geolocation_city = '´teresopolis';

select geolocation_city from geolocation 
where geolocation_city = '´teresopolis';


UPDATE geolocation
SET geolocation_city = 'quarto centenario'
WHERE geolocation_city = '4o. centenario';

UPDATE geolocation
SET geolocation_city = REGEXP_REPLACE(geolocation_city, '^\\.+', '')
WHERE geolocation_city REGEXP '^\\.+';

UPDATE geolocation
SET geolocation_city = REGEXP_REPLACE(geolocation_city, '^\\*+', '')
WHERE geolocation_city REGEXP '^\\*+';

UPDATE geolocation
SET geolocation_city = 'sao paulo'
WHERE geolocation_city IN ('sp', 'sao paulo ', 'sao-paulo', 'sao_paulo');

UPDATE geolocation
SET geolocation_city = 'sao paulo'
WHERE geolocation_city = 'saopaulo';

UPDATE geolocation
SET geolocation_city = 'mogi das cruzes'
WHERE geolocation_city = 'mogidascruzes';

UPDATE geolocation
SET geolocation_city = 'embu guacu'
WHERE geolocation_city = 'embuguacu';

UPDATE geolocation
SET geolocation_city = 'biritiba mirim'
WHERE geolocation_city = 'biritibamirim';



SELECT geolocation_city
FROM geolocation
WHERE geolocation_city != TRIM(geolocation_city);

UPDATE geolocation
SET geolocation_city = TRIM(geolocation_city);



UPDATE geolocation
SET geolocation_city =
TRIM(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
geolocation_city,
'&apos;', ''''),
'&oacute;', 'o'),
'&aposoeste', '''oeste'),
'³','a'),
'`', ''''),
'  ',' ')
)
WHERE geolocation_city REGEXP '&|³|`|  ';





SELECT geolocation_city
FROM geolocation
WHERE geolocation_city REGEXP '[^a-z0-9 ''().,-]';


SELECT geolocation_city
FROM geolocation
WHERE geolocation_city = 'socorro do';

SELECT 
    REPLACE(geolocation_city, '-', '') AS normalized_name,
    COUNT(*) AS occurrences
FROM geolocation
GROUP BY normalized_name
HAVING COUNT(*) > 1;



SELECT DISTINCT c.customer_city
FROM customers_1 c
LEFT JOIN geolocation g
    ON c.customer_city = g.geolocation_city
WHERE g.geolocation_city IS NULL;-- this query is taking time to run so we used query below





SELECT DISTINCT c.customer_city
FROM customers_1 c
WHERE NOT EXISTS (
    SELECT 1
    FROM geolocation g
    WHERE g.geolocation_city = c.customer_city
); -- checking that that the data we cleaned (city names) are matching with the other tables city names or not.

/*count how many orders/customers each of these 50 cities appear in using a simple SQL query. 
This will help you decide whether they are high-volume or really just minor contributors.*/


SELECT c.customer_city, COUNT(*) AS city_count
FROM customers_1 c
WHERE c.customer_city IN (
    'palmeirinha', 'alto sao joao', 'perola independente', 'mussurepe',
    'colonia jordaozinho', 'maioba', 'conceicao do formoso', 'domiciano ribeiro',
    'monnerat', 'missi', 'sao miguel do cambui', 'sao francisco do humaita',
    'nucleo residencial pilar', 'ibitioca', 'piacu', 'santo eduardo',
    'guariroba', 'nossa senhora do remedio', 'bora', 'guinda', 'siriji',
    'sao clemente', 'pinhotiba', 'sao vitor', 'ajapi', 'jaguarembe',
    'palmital de minas', 'bom jesus do querendo', 'taboquinhas',
    'polo petroquimico de triunfo', 'poco de pedra', 'mampituba', 'jaua',
    'pitanga de estrada', 'cuite velho', 'glaura', 'estevao de araujo',
    'bemposta', 'humildes', 'caldas do jorro', 'itabi', 'passagem',
    'doce grande', 'sambaiba', 'sao sebastiao da serra', 'angelo frechiani',
    'major porto', 'aribice', 'cipo-guacu', 'sao sebastiao do paraiba'
)
GROUP BY c.customer_city
ORDER BY city_count DESC;

/*Leaving them as-it-is, is okay, 
but best practice is group them as “Other” to avoid empty/null city metrics in dashboards.*/

UPDATE customers_1
SET customer_city = 'Other'
WHERE customer_city IN (
    'palmeirinha', 'alto sao joao', 'perola independente', 'mussurepe',
    'colonia jordaozinho', 'maioba', 'conceicao do formoso', 'domiciano ribeiro',
    'monnerat', 'missi', 'sao miguel do cambui', 'sao francisco do humaita',
    'nucleo residencial pilar', 'ibitioca', 'piacu', 'santo eduardo',
    'guariroba', 'nossa senhora do remedio', 'bora', 'guinda', 'siriji',
    'sao clemente', 'pinhotiba', 'sao vitor', 'ajapi', 'jaguarembe',
    'palmital de minas', 'bom jesus do querendo', 'taboquinhas',
    'polo petroquimico de triunfo', 'poco de pedra', 'mampituba', 'jaua',
    'pitanga de estrada', 'cuite velho', 'glaura', 'estevao de araujo',
    'bemposta', 'humildes', 'caldas do jorro', 'itabi', 'passagem',
    'doce grande', 'sambaiba', 'sao sebastiao da serra', 'angelo frechiani',
    'major porto', 'aribice', 'cipo-guacu', 'sao sebastiao do paraiba'
);
SET SQL_SAFE_UPDATES = 1;


SELECT DISTINCT s.seller_city
FROM sellers s
LEFT JOIN geolocation g
    ON s.seller_city = g.geolocation_city
WHERE g.geolocation_city IS NULL; -- checking that that the data we cleaned (city names) are matching with the other tables city names or not.

-- CORRECTING TYPING MISTAKES

UPDATE sellers
SET seller_city = CASE
    WHEN seller_city = 'sao jose do rio pret' THEN 'sao jose do rio preto'
    WHEN seller_city = 'scao jose do rio pardo' THEN 'sao jose do rio pardo'
    WHEN seller_city = 'sao bernardo do capo' THEN 'sao bernardo do campo'
    WHEN seller_city = 'floranopolis' THEN 'florianopolis'
    WHEN seller_city = 'belo horizont' THEN 'belo horizonte'
    WHEN seller_city = 'sando andre' THEN 'santo andre'
    WHEN seller_city = 's jose do rio preto' THEN 'sao jose do rio preto'
    WHEN seller_city = 'ji parana' THEN 'ji-paraná'
    WHEN seller_city = 'garulhos' THEN 'guarulhos'
    ELSE seller_city
END;


UPDATE sellers
SET seller_city = CASE
    WHEN seller_city = 'sao miguel d''oeste' THEN 'sao miguel do oeste'
    WHEN seller_city = 'balenario camboriu' THEN 'balneario camboriu'
    WHEN seller_city = 'tabao da serra' THEN 'taboao da serra'
    WHEN seller_city = 'ao bernardo do campo' THEN 'sao bernardo do campo'
    WHEN seller_city = 'sao jose dos pinhas' THEN 'sao jose dos pinhais'
    ELSE seller_city
END;

-- PUTTING REAMAINING 11 CITIES UNDER 'OTHER' CATEGORIES

UPDATE sellers
SET seller_city = 'Other'
WHERE seller_city IN (
    'paincandu', 'minas gerais', 'castro pires', 'cascavael', 'bahia',
    'portoferreira', 'vicente de carvalho', 'santa catarina', 'juzeiro do norte', 'centro'
);


-- 9. ***********************************   product translation table  ****************************************

SELECT * FROM product_category_translation ;-- originally had 2 colms , later we added one called grouped_category_english

SELECT COUNT(*) FROM product_category_translation; -- 73 ROWS RETURNED BUT OUR OIRGINAL CSV HAS 71 ROWS , in sql on 1 extra row is coming for 'pc_gamer' and excel csv row number 65 there is a issue (table colm name instead of category name) but in sql instead of that it imported on category name called 'portable kitchen appliances'

SELECT product_category_name_english, COUNT(*) AS cnt
FROM product_category_translation
GROUP BY product_category_name
ORDER BY cnt desc; -- 73 rows returned 

-- fixing typing mistakes in english translation column

-- Fix 1
UPDATE product_category_translation
SET product_category_name_english = 'construction_tools'
WHERE product_category_name_english =  'construction_tools_construction\r'
;

UPDATE product_category_translation
SET product_category_name_english = 'construction_tools'
WHERE product_category_name_english =  'costruction_tools_tools\r'
;



-- Fix 2
UPDATE product_category_translation
SET product_category_name_english = 'construction_tools_garden'
WHERE product_category_name_english = 'costruction_tools_garden\r'
;

-- Fix 3
UPDATE product_category_translation
SET product_category_name_english = 'fashion_female_clothing'
WHERE product_category_name_english = 'fashio_female_clothing\r'
;

-- Fix 4
UPDATE product_category_translation
SET product_category_name_english = 'home_comfort'
WHERE product_category_name_english = 'home_confort\r';



-- MOST OF THE SUBCATEGORIES FALLS UNDER SAME DOMAIN SO WE WILL TRY TO BRING THEM UNDER SINGLE CATEGORY NAME, 
	-- We will create an extra colm in the translation table and group categories in that table without changing values in the original table


SELECT distinct product_category_name from product_category_translation; -- 73 ROWS
SELECT distinct product_category_name_english from product_category_translation; -- 73 ROWS

ALTER TABLE product_category_translation
ADD COLUMN grouped_category_english VARCHAR(100);



UPDATE product_category_translation
	SET grouped_category_english = 'Kitchen Appliances'
WHERE product_category_name IN (
	'moveis_cozinha_area_de_servico_jantar_e_jardim',
	'la_cuisine',
	'portateis_casa_forno_e_cafe','utilidades_domesticas','eletroportateis'
);




UPDATE product_category_translation
	SET grouped_category_english = 'Fashion'
WHERE product_category_name IN (
    'fashion_bolsas_e_acessorios',
    'fashion_calcados',
    'fashion_roupa_masculina',
    'fashion_underwear_e_moda_praia',
    'fashion_esporte',
    'fashion_roupa_feminina',
    'fashion_roupa_infanto_juvenil'
);

UPDATE product_category_translation
	SET grouped_category_english = 'Construction & Tools'
WHERE product_category_name IN (
    'construcao_ferramentas_construcao',
    'construcao_ferramentas_jardim',
    'construcao_ferramentas_ferramentas',
    'construcao_ferramentas_iluminacao',
    'construcao_ferramentas_seguranca'
);

UPDATE product_category_translation
	SET grouped_category_english = 'Arts'
WHERE product_category_name IN ('artes', 'artes_e_artesanato');


UPDATE product_category_translation
	SET grouped_category_english = 'Foods and Beverages'
WHERE product_category_name IN ('alimentos', 'alimentos_bebidas','bebidas');

UPDATE product_category_translation
	SET grouped_category_english = 'Computers and Consoles'
WHERE product_category_name IN ('informatica_acessorios','consoles_games','pcs','pc_gamer','tablets_impressao_imagem');


UPDATE product_category_translation
	SET grouped_category_english = 'Sports & Leisure'
WHERE product_category_name IN (
    'brinquedos',
    'esportes_e_lazer','esporte_lazer'
);


UPDATE product_category_translation
	SET grouped_category_english = 'Furniture'
WHERE product_category_name IN (
	'cama_mesa_banho',
	'moveis_decoracao',
	'moveis_cozinha_area_de_servico_jantar_e_jardim',
	'moveis_escritorio',
	'moveis_colchao_e_estofado',
	'moveis_sala',
	'moveis_quarto');

UPDATE product_category_translation
	SET grouped_category_english = 'Music and Media'
WHERE product_category_name IN (
	'audio',
	'instrumentos_musicais',
	'musica',
	'dvds_blu_ray',
	'cds_dvds_musicais');

select * from product_category_translation;

UPDATE product_category_translation
	SET grouped_category_english = 'Garden Tools'
WHERE product_category_name IN (
	'ferramentas_jardim'
);

UPDATE product_category_translation
	SET grouped_category_english = 'Beauty & Fragrance'
WHERE product_category_name IN (
	'perfumaria'
);




UPDATE product_category_translation
	SET grouped_category_english = 'Books'
WHERE product_category_name IN (
	'papelaria',
	'livros_tecnicos',
	'livros_interesse_geral',
	'livros_importados'
);


UPDATE product_category_translation
	SET grouped_category_english = 'Telephony'
WHERE product_category_name IN (
	'telefonia','telefonia_fixa'
);


UPDATE product_category_translation
	SET grouped_category_english = 'Security and Services'
WHERE product_category_name IN (
	'seguros_e_servicos',
	'sinalizacao_e_seguranca'
);

UPDATE product_category_translation
	SET grouped_category_english = 'Watches and Gifts'
WHERE product_category_name IN (
	'relogios_presentes'
);



UPDATE product_category_translation
	SET grouped_category_english = 'Agro Industry'
WHERE product_category_name IN (
	'agro_industria_e_comercio'
);

UPDATE product_category_translation
	SET grouped_category_english = 'Party Events'
WHERE product_category_name IN (
	'artigos_de_festas',
	'artigos_de_natal'
);

UPDATE product_category_translation
	SET grouped_category_english = 'Automobile'
WHERE product_category_name IN (
	'automotivo'
);



UPDATE product_category_translation
	SET grouped_category_english = 'Home and Living'
WHERE product_category_name IN (
	'casa_conforto',
	'casa_conforto_2'
);

UPDATE product_category_translation
	SET grouped_category_english = 'Home Construction'
WHERE product_category_name IN (
	'casa_construcao'
);


UPDATE product_category_translation
	SET grouped_category_english = 'Home Appliances'
WHERE product_category_name IN (
	'eletrodomesticos',
	'eletrodomesticos_2',
	'climatizacao'
);


UPDATE product_category_translation
	SET grouped_category_english = 'Electronics'
WHERE product_category_name IN (
	'eletronicos','cine_foto'
);


UPDATE product_category_translation
	SET grouped_category_english = 'Business & Industrial'
WHERE product_category_name IN (
	'industria_comercio_e_negocios'
);

UPDATE product_category_translation
	SET grouped_category_english = 'Miscellaneous'
WHERE product_category_name IN (
	'cool_stuff'
);

UPDATE product_category_translation
	SET grouped_category_english = 'Pet Supplies'
WHERE product_category_name IN (
	'pet_shop'
);

SELECT * FROM product_category_translation;
