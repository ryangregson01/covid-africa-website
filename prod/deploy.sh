#!/bin/bash

DEPLOY_DIR=../deploy

# Configure cert-manager for ACME registration and deployment.
microk8s kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml

# Configure ClickHouse
microk8s kubectl apply -f $DEPLOY_DIR/clickhouse.yml
microk8s kubectl apply -f $DEPLOY_DIR/clickhouse-data.yml
microk8s kubectl create configmap clickhouse-config --from-file=../clickhouse/ --dry-run=client -o yaml | microk8s kubectl apply -f -
microk8s kubectl apply -f $DEPLOY_DIR/database-refresher.yml

# Configure webapp
microk8s kubectl apply -f $DEPLOY_DIR/webapp-config.yml
microk8s kubectl apply -f $DEPLOY_DIR/webapp-data.yml
microk8s kubectl apply -f $DEPLOY_DIR/webapp.yml

# Delay creating the CSR until cert-manager has initialised.
echo
echo
echo "Waiting 1m for cert-manager to initialise..."
echo "If the commands fail then run until they succeed:"
echo "microk8s microk8s kubectl apply -f letsencrypt-prod.yml"
echo "microk8s microk8s kubectl apply -f covid-africa-crt.yml"

sleep 60
microk8s kubectl apply -f letsencrypt-prod.yml
microk8s kubectl apply -f covid-africa-crt.yml

# Deploy Ingress
microk8s kubectl apply -f ingress.yml
