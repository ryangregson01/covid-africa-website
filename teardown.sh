#!/bin/bash

kubectl delete -f deploy/ingress.yml
kubectl delete -f deploy/database-refresher.yml
kubectl delete -f deploy/clickhouse.yml
kubectl delete -f deploy/webapp-dev.yml
