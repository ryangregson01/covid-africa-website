#!/bin/sh

apt update
apt install snapd
# Install microk8s
snapd install microk8s --classic --channel=1.21

# Deploy Kubernetes cluster.
microk8s status --wait-ready
microk8s enable dns storage ingress storage rbac
microk8s start

./deploy.sh
# Pull in initial data for the database.
microk8s kubectl exec -it $(kubectl get po | grep "database-refresher" | cut -d' ' -f1) -- ./harvester.sh
