#!/bin/bash
minikube start --driver=docker --mount --mount-string $(pwd)/covid_dashboard/:/covid_dashboard
minikube addons enable ingress

MINIKUBE_IP=$(minikube ip)
echo $MINIKUBE_IP   covid-africa.info
echo $MINIKUBE_IP   covid-africa.com
