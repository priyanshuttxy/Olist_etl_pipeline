import pandas as pd
import kagglehub
from sqlalchemy import create_engine
from sqlalchemy import text

path = kagglehub.dataset_download("olistbr/brazilian-ecommerce")

customer_ds =  pd.DataFrame(pd.read_csv(f"{path}/olist_customers_dataset.csv", encoding="latin1"))
geolocation_ds = pd.DataFrame(pd.read_csv(f"{path}/olist_geolocation_dataset.csv", encoding="latin1"))
order_items_ds =  pd.DataFrame(pd.read_csv(f"{path}/olist_order_items_dataset.csv", encoding="latin1"))
order_payments_ds = pd.DataFrame(pd.read_csv(f"{path}/olist_order_payments_dataset.csv", encoding="latin1"))
order_reviews_ds = pd.DataFrame(pd.read_csv(f"{path}/olist_order_reviews_dataset.csv", encoding="latin1"))
orders_ds =  pd.DataFrame(pd.read_csv(f"{path}/olist_orders_dataset.csv", encoding="latin1"))
products_ds = pd.DataFrame(pd.read_csv(f"{path}/olist_products_dataset.csv", encoding="latin1"))
sellers_ds = pd.DataFrame(pd.read_csv(f"{path}/olist_sellers_dataset.csv", encoding="latin1"))
product_category_ds = pd.DataFrame(pd.read_csv(f"{path}/product_category_name_translation.csv", encoding="latin1"))

ds={"customer" : customer_ds, "geolocation" : geolocation_ds, "order_items": order_items_ds, "order_payments": order_payments_ds, 
    "order_reviews" : order_reviews_ds, "orders" : orders_ds, "products" : products_ds,
    "sellers" : sellers_ds, "product_category" : product_category_ds}

product_category_ds.rename(
    columns={"ï»¿product_category_name": "product_category_name"},
    inplace=True
)

engine = create_engine("postgresql://postgres:829122@localhost:5432/olistdb")

customer_ds.to_sql('customers_raw', engine, if_exists='append', index=False)
geolocation_ds.to_sql('geolocation_raw', engine, if_exists='append', index=False)
order_items_ds.to_sql('order_items_raw', engine, if_exists='append', index=False)
order_payments_ds.to_sql('order_payments_raw', engine, if_exists='append', index=False)
order_reviews_ds.to_sql('order_reviews_raw', engine, if_exists='append', index=False)
orders_ds.to_sql('orders_raw', engine, if_exists='append', index=False)
products_ds.to_sql('products_raw', engine, if_exists='append', index=False)
sellers_ds.to_sql('sellers_raw', engine, if_exists='append', index=False)
product_category_ds.to_sql('product_category_raw', engine, if_exists='append', index=False)