import pandas as pd

items = pd.read_csv("olist_order_items_dataset.csv")
payments = pd.read_csv("olist_order_payments_dataset.csv")

#collapsing items table to contain one row per order such that
# we can aggregate the total price and the total freight of the entire order.

items_agg = items.groupby('order_id', as_index=False).agg(
    total_order_price=('price', 'sum'),
    total_freight=('freight_value', 'sum')
)

#Defining a new column that combines price and freight to get the total
#money charged per order

items_agg['total_charged'] = items_agg['total_order_price'] + items_agg['total_freight']

print(items_agg.head(20))

# Collapsing payments table to contain one row per order so that we
# can aggregate the total amount that was actually paid.

payments_agg = payments.groupby('order_id', as_index=False).agg(
    total_paid = ('payment_value', 'sum'),
    no_of_payment_methods = ('payment_type', 'nunique')
)

print(payments_agg.head(20))

items_agg.to_csv("items_by_order.csv", index=False)
payments_agg.to_csv("payments_by_order.csv", index=False)

from sqlalchemy import create_engine
engine = create_engine('mysql+pymysql://root:thousand@localhost/order_reconciliations')
items_agg.to_sql('items_by_order', engine, if_exists='replace', index=False)
payments_agg.to_sql('payments_by_order', engine, if_exists='replace', index=False)