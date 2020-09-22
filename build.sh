#!/bin/bash

node_ready=$(kubectl get nodes | grep node-1 | awk '{print $2}')
if [[ $node_ready == "Ready" ]]; then
    echo "Node is ready!"
else
    exit 1
fi

# Change workdir
cd /vagrant/app

# Deploy the mysql pod
kubectl apply -f mysql.yaml

# Build the application
docker build -t busayr/hello-devops . --no-cache

# Define image_id environment variable
IMAGE_ID=$(docker images |grep 'busayr/hello-devops ' | awk '{print $3}')
echo "IMAGE ID is ${IMAGE_ID}"

# Tag docker image
docker tag busayr/hello-devops:latest busayr/hello-devops-dev:${IMAGE_ID}

# Update app.yaml file
sed -i -e "s#image:.*#image: busayr/hello-devops-dev:${IMAGE_ID}#g" app.yaml

# Check mysql is running
mysql_pod=$(kubectl get pods | grep "mysql" | awk '{print $1}')
until [ "$(kubectl get pods | grep "mysql" | awk '{print $1,$2,$3}')" == "$mysql_pod 1/1 Running" ]
do
    if [[ ${#mysql_pod} < 1 ]]; then
    mysql_pod=$(kubectl get pods | grep "mysql" | awk '{print $1}')
    echo "There is no mysql server, waiting..."
    sleep 5
    continue
    fi
    echo -n "Waiting for mysql pod become ready..."
    sleep 5
done
printf "\nmysql pod is ready!\n"

# Deploy the app
kubectl apply -f app.yaml

# Verify the app version
APP_VERSION=$(kubectl get deploy hello-devops -o yaml |grep "image: busayr/hello-devops" | awk '{print $2}')

# I have found this simple pattern for finding the private IP address of the node host. 
# I'm not sure is guaranteed way but I tried 10 times and seems stable.
# Maybe can be changed later
NODE_IP_ADDRESS=$(hostname -I |awk '{print $2}') 

echo ""
echo "#########"
echo " The application running on the '${APP_VERSION}' image."
echo " ---------------------------------------------------------- "
echo " You can access http://${NODE_IP_ADDRESS}:30300 "
echo "#########"
echo ""