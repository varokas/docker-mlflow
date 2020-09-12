FROM python:3.8-slim

RUN pip install mlflow==1.11.0 psycopg2-binary==2.8.5 boto3==1.13.4

RUN mkdir /mlflow
WORKDIR /mlflow

RUN apt-get update \
    && apt-get install -y curl unzip \
    && apt-get clean \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf ./aws \
    && rm awscliv2.zip

COPY entrypoint.sh /mlflow/entrypoint.sh
RUN chmod +x /mlflow/entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/mlflow/entrypoint.sh"]
