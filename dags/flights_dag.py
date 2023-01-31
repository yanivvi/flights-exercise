from airflow import DAG
from airflow.operators.dummy import DummyOperator
from airflow.operators.python import PythonOperator
from airflow.sensors.filesystem import FileSensor
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago
from airflow.models.baseoperator import chain,cross_downstream 
from datetime import datetime, timedelta
from sqlalchemy import create_engine
import requests
import pandas as pd
import os


def connect_to_db(host= '***.***.*.*',db = 'postgres',user = 'postgres', password = 'password', port = 5433):
    host= 'use your own public ip address'
    return create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

def get_flights():
    flights_url = f'https://data.gov.il/api/3/action/datastore_search?resource_id=e83f763b-b7d7-479e-b172-ae981ddc6de5&limit=10000'
    flights_data = requests.get(flights_url).json()
    df = pd.DataFrame.from_dict(flights_data['result']['records'])
    df.to_sql('mrr_flights', connect_to_db(),if_exists='replace',index=False)
 
def get_countries():
    countries_url = 'https://www.geonames.org/countries/'
    df = pd.read_html(countries_url)[1]
    df.to_sql('mrr_countries', connect_to_db(),if_exists='replace')

default_args = {
    'retries' : 5,
    'retry_interval': timedelta(minutes=5)
}



with DAG(dag_id= 'flights_data', schedule= "@hourly" 
        ,start_date= days_ago(2), catchup = False) as dag:
    
    mirror_flights = PythonOperator(
        task_id='mirror_flights',
        python_callable=get_flights
    )

    mirror_countries = PythonOperator(
        task_id='mirror_countries',
        python_callable=get_countries
    )

    dbt_step1 = BashOperator(
        task_id='dbt_step',
        bash_command='cd /opt/airflow/dbt && dbt run'
    )

    [mirror_flights,mirror_countries] >> dbt_step1

 
