#!/bin/bash

DEPLOY_DIR=../deploy

# Configure cert-manager for ACME registration and deployment.
microk8s kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml
microk8s kubectl delete -f letsencrypt-prod.yml
microk8s kubectl delete -f covid-africa-crt.yml

# Configure ClickHouse
microk8s kubectl delete -f $DEPLOY_DIR/clickhouse.yml
microk8s kubectl delete configmap clickhouse-config
microk8s kubectl delete -f $DEPLOY_DIR/database-refresher.yml

# Configure webapp
microk8s kubectl delete -f $DEPLOY_DIR/webapp-config.yml
microk8s kubectl delete -f $DEPLOY_DIR/webapp.yml

# Deploy Ingress
microk8s kubectl delete -f ingress.yml
