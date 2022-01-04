# syntax=docker/dockerfile:1

FROM python:3.9-alpine

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apk update \
    && apk add gcc musl-dev \
    && adduser --system django \
    && mkdir -p /var/lib/covid-dashboard

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

USER django
ENTRYPOINT ["/app/entrypoint.sh"]
