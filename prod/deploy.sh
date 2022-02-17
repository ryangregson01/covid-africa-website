#!/bin/bash

DEPLOY_DIR=../deploy

# Configure cert-manager for ACME registration and deployment.
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml
kubectl apply -f letsencrypt-staging.yml
kubectl apply -f covid-africa-crt.yml

# Configure ClickHouse
kubectl apply -f $DEPLOY_DIR/clickhouse.yml
kubectl apply -f $DEPLOY_DIR/clickhouse-data.yml
kubectl create configmap clickhouse-config --from-file=../clickhouse/ --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f $DEPLOY_DIR/database-refresher.yml

# Configure webapp
kubectl apply -f $DEPLOY_DIR/webapp-config.yml
kubectl apply -f $DEPLOY_DIR/webapp-data.yml
kubectl apply -f $DEPLOY_DIR/webapp.yml

# Deploy Ingress
kubectl apply -f ingress.yml
