#!/bin/bash

kubectl apply -f deploy/database-refresher.yml
kubectl apply -f deploy/webapp-config.yml
kubectl create configmap clickhouse-config --from-file=clickhouse/ \
    --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f deploy/clickhouse-data.yml
kubectl apply -f deploy/webapp-data.yml
kubectl apply -f deploy/clickhouse.yml
kubectl apply -f deploy/webapp-dev.yml
kubectl apply -f deploy/ingress.yml
