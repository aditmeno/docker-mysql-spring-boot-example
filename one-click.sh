#!/bin/bash

##### One command solution to provision a minikube cluster and deploy the app a d mysql database

if [ "$#" -ne 5 ]; then
  echo "Usage: $0 <App Version> <Docker Image Tag Name> <Docker Username> <Dockerfile> <Terraform variables File path>"
  exit 1
fi

./build-docker.sh $1 $2 $3 $4

cd mysql-replica
cd master
./build-docker.sh $1 mysql-master $3 $4
cd ../slave
./build-docker.sh $1 mysql-slave $3 $4

cd ../../

cd infrastructure

terraform init
terraform plan 
terraform apply -auto-approve -var-file="$5"
