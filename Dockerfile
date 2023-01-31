FROM apache/airflow:2.5.1
ENV  DOCKER_DEFAULT_PLATFORM=linux/amd64  
COPY requirements.txt ./
RUN pip install -r requirements.txt