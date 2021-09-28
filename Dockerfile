FROM python:3.7.3-alpine3.10

RUN apk add --no-cache --virtual .google-cloud-build \
    g++ \
    libffi-dev \
    && pip3 install --no-cache-dir google-cloud-bigquery \
    && apk del .google-cloud-build

COPY ./src /app

ENTRYPOINT ["python3", "/app/app.py"]
