import numpy as np
import pandas as pd
from faker import Faker
from sqlalchemy import create_engine

print('1. Chargement du fichier Excel')
df = pd.read_excel('Online Retail.xlsx', sheet_name='Online Retail')

print(f'Nombre de lignes initiales : {len(df):,}')

df = df.dropna(subset=['CustomerID'])

df = df[df['Quantity'] > 0]
df = df[df['UnitPrice'] > 0]

df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'])

df['TotalRevenue'] = df['Quantity'] * df['UnitPrice']

print('4. Simulation de données récentes')
fake = Faker()
recent_data = []

for _ in range(5000):
  recent_data.append({
      'InvoiceNo': f'SIM_{fake.unique.random_number(digits=6)}',
      'StockCode': fake.random_element(
          elements=['85123A', '71053', '84406B', '84029G']
      ),
      'Description': fake.catch_phrase(),
      'Quantity': fake.random_int(min=1, max=15),
      'InvoiceDate': fake.date_time_between(
          start_date='-1y', end_date='now'
      ),  # sur la dernière année
      'UnitPrice': round(fake.random.uniform(2.5, 50.0), 2),
      'CustomerID': fake.random_int(min=12000, max=18000),
      'Country': fake.random_element(
          elements=['United Kingdom', 'France', 'Germany', 'Spain']
      ),
  })

df_simulated = pd.DataFrame(recent_data)
df_simulated['TotalRevenue'] = (
    df_simulated['Quantity'] * df_simulated['UnitPrice']
)

df_final = pd.concat([df, df_simulated], ignore_index=True)
print(f'Nombre de lignes après nettoyage et simulation : {len(df_final):,}')

print('5. Connexion à PostgreSQL et création du modèle en étoile...')
engine = create_engine(
    'postgresql://postgres:Jadart2001?@localhost:5432/ecommerce_db'
)

dim_customer = df_final[['CustomerID', 'Country']].drop_duplicates().copy()
dim_customer.to_sql(
    'dim_customer', engine, if_exists='replace', index=False
)

dim_product = (
    df_final[['StockCode', 'Description']]
    .drop_duplicates(subset=['StockCode'])
    .copy()
)
dim_product.to_sql('dim_product', engine, if_exists='replace', index=False)

fact_sales = df_final[
    [
        'InvoiceNo',
        'StockCode',
        'CustomerID',
        'Quantity',
        'InvoiceDate',
        'UnitPrice',
        'TotalRevenue',
    ]
].copy()
fact_sales.to_sql('fact_sales', engine, if_exists='replace', index=False)

print('ETL terminé')