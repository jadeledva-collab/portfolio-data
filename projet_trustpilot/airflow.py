from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
import pandas as pd
import sqlite3
import os

default_args = {
    'owner': 'data_engineer',
    'depends_on_past': False,
    'email_on_failure': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'trustpilot_etl_pipeline',
    default_args=default_args,
    description='Pipeline ETL quotidien des avis Trustpilot vers SQLite',
    schedule_interval='@daily',  # S'exécute 1 fois par jour
    start_date=datetime(2026, 1, 1),
    catchup=False,
) as dag:

    def run_etl():
        fichier_csv = "trust_pilot_reviews_data_2022_06.csv"
        db_name = "trustpilot.db"
        
        if not os.path.exists(fichier_csv):
            raise FileNotFoundError(f"Le fichier {fichier_csv} est introuvable.")
            
        df = pd.read_csv(fichier_csv)
        
        df = df.drop_duplicates()
        df['texte'] = df['texte'].astype(str).str.replace('\n', ' ', regex=True).str.strip()
        df = df.dropna(subset=['texte'])
        
        conn = sqlite3.connect(db_name)
        df[['auteur', 'note', 'texte']].to_sql('reviews', conn, if_exists='append', index=False)
        conn.close()
        print("ETL exécuté avec succès via Airflow !")

    etl_task = PythonOperator(
        task_id='execution_etl_complet',
        python_callable=run_etl,
    )