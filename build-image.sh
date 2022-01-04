#!/bin/bash

set -e

eval "$(minikube docker-env --shell=bash)"
docker build -t johnlemmon/covid-dashboard covid_dashboard
docker build -t johnlemmon/database-refresher database-refresher
eval "$(minikube docker-env -u --shell=bash)"

./deploy.sh
