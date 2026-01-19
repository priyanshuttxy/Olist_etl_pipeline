/*create constrain*/

SELECT * FROM clean.customers
SELECT * FROM clean.geolocation

ALTER TABLE clean.customers
ADD PRIMARY KEY(customer_id);

/*ALTER TABLE clean.customers
ADD CONSTRAINT fk_customers_geo
FOREIGN KEY (customer_zip_code_prefix)
REFERENCES clean.geolocation(geolocation_zip_code_prefix)*/

ALTER TABLE clean.orders
ADD PRIMARY KEY(order_id);

ALTER TABLE clean.orders
ADD CONSTRAINT fk_ord_cust
FOREIGN KEY (customer_id)
REFERENCES clean.customers(customer_id);
/*Done Order Table*/

ALTER TABLE clean.order_payments
ADD CONSTRAINT fk_pay_ord
FOREIGN KEY (order_id)
REFERENCES clean.orders(order_id);
/*Done Payment Table*/

ALTER TABLE clean.order_reviews
ADD PRIMARY KEY(review_id);

ALTER TABLE clean.order_reviews
ADD CONSTRAINT fk_rev_ord
FOREIGN KEY (order_id)
REFERENCES clean.orders(order_id);
/*Done review table*/

ALTER TABLE clean.sellers
ADD PRIMARY KEY(seller_id);
/*Done seller table*/

ALTER TABLE clean.product_category
RENAME COLUMN ï»¿product_category_name TO product_category_name;

ALTER TABLE clean.product_category
ADD PRIMARY KEY(product_category_name);
/*Done Product Category*/

ALTER TABLE clean.products
ADD PRIMARY KEY(product_id);
/*Done Products table*/

ALTER TABLE clean.order_items
ADD CONSTRAINT pk_ord_orditm
PRIMARY KEY (order_id, order_item_id);


ALTER TABLE clean.order_items
ADD CONSTRAINT pk_orditms_ord
FOREIGN KEY (order_id)
REFERENCES clean.orders(order_id);

ALTER TABLE clean.order_items
ADD CONSTRAINT pk_orditms_prd
FOREIGN KEY (product_id)
REFERENCES clean.products(product_id);

ALTER TABLE clean.order_items
ADD CONSTRAINT pk_orditms_sell
FOREIGN KEY (seller_id)
REFERENCES clean.sellers(seller_id);
/*Done order items*/