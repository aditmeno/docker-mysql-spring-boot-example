# SO1 DevOps Assignment

DevOps task to deploy a Java Spring Boot app backed by a MySQL database

Project seeks to automate deployment to a k8s instance

Stack Used :-
1. Java Spring Boot Example App 
2. MySQL 
3. Terraform 
4. Minikube

## Prerequisites
This project assumes you have already installed and setup
1. Docker
2. Terraform
3. Kubernetes cluster (Minikube)
4. A *nix like system. Currently won't support Windows unless under WSL(Windows Subsystem for Linux)
5. Modify the variables.tf variable `mysql_master_password` and `mysql_replication_password` to secure your deployment. A default has been set there which isn't secure/strong password. Consider using the terraform.tfvars file

## Setup
The one-click.sh script will build the docker image and create a new minikube instance with the app and MySQL backing service

All applications and services are deployed to dev namespace, this can be changed by setting the namespace variable in the terraform modules folder 

one-click.sh expects 5 arguments, namely :-
1. App version (eg:- v1)
2. Docker Image Tag Name - What the image image will be named in the docker repo
3. Username - Username used to login to docker hub. Needed to upload the image 
4. Dockerfile - File used to build the docker image
5. TFVAR file - Path to the file if you need to override the default variables, or need to pass mysql db and replication password (a default can be used my navigating to the infrastructure directory and deploying, but not recommended)

## Accessing SO1-java-app and MySQL DB in minikube
Java app is accessible over the service so1-java-app.dev 
MySQL is accessible over the service mysql-master.dev 

A way of access the services via a temporary pod :-
1. Spin up a container - kubectl run test-client --rm --tty -i --restart='Never' --namespace dev --image docker.io/curlimages/curl:latest --command -- /bin/sh
2. Run the command - curl so1-java-app.dev:8086/all/
3. Verify the json content is returned

### Point 5 - Can you do a HA of a database? Any way to keep the data persistent when pods are recreated?
Implemented MySQL HA via replication cluster. 

In this setup only a single master and single slave node exists due to memory constraints on present system used to test

Another alternative is to set two active MySQL nodes which write data asynchronously to each other while also writing the data to replication servers to ensure maximum availability

Adding persistent volume and a persistent volume claim to both master and slave MySQL will persist data across pod recreation. Not implemented in pv and pvc as it caused the container to fail as MySQL refused to initialize if the data directory is not empty (lost+found was causing the issue, deleting this folder is unwise). If the volume is mounted as a sub directory, all users lose access to login to the DB including root. 

TODO :- Figure out a way to solve this bug with mounted volumes on MySQL

Ideally a managed database solution should be used as this reduces the vector of change failure and provides better security and data protection features than would be possible on a k8s instance.

### Point 6 - Add CI to the deployment process.
CI/CD solutions like Concourse CI or GoCD could be used to pull changes from java app git repo, run tests via mvn to ensure a broken build doesn't go through the pipeline and a build stage could then be triggered to build the docker images relating to the Java App and MySQL master and slave, and upload these images to a registry which can in turn be pulled by Kubernetes and deployed

GitOps is also an option where all code changes and config are stored in a git repo and any change made in the git repo would immediately trigger a full build, test, release cycle with managed environments to test the new change. Eg Jenkins X

### Point 7 - Split your deployment into prod/qa/dev environment.
Kubernetes namespaces are an ideal way to split apps based on environment. Namespaces for dev, prod and qa are implemented in the solution, but only dev is used to deploy app and MySQL images

Another option is to spin up 3 separate k8 instances if business rules demands completely isolated environments

### Point 8 - Please suggest a monitoring solution for your system. How would you notify an admin that the resources are scarce?
Adding Prometheus server in each pod would be an ideal way to monitor metrics. Node exporter can be used to extract metrics. These metrics could be streamed to a message queue which a monitoring application like CloudWatch or StackDriver could consume, and generate alerts based on metrics being monitored and if a message matches a alarm trigger pattern, a serverless function/application could be kicked off to alert admin of the issue

Graphana or Kibana would be good tool to visualize the metrics and setup alerting based on rules around the metric being monitored

AWS X-Ray could also be used to trace the time taken to send network calls in the app, which could help in improving potential bottlenecks in the code

Tried implementing locally but was halted as RAM ran out and the k8s became generally unresponsive 

TODO :- Implement monitoring solutions for app
