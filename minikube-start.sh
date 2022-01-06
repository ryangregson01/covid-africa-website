#!/bin/bash
minikube start \
    --driver=docker \
    --mount --mount-string $(pwd)/covid_dashboard/:/covid_dashboard \
    --extra-config=apiserver.authorization-mode=Node,RBAC || exit $?

minikube addons enable ingress || exit $?

MINIKUBE_IP=$(minikube ip)
echo $MINIKUBE_IP   covid-africa.info
echo $MINIKUBE_IP   covid-africa.com
