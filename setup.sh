#!/bin/bash

set -o errexit  # Exit on any command failing
set -o pipefail # Return non-zero status if any part of a pipeline fails

# Docker Hub credentials
DOCKER_USERNAME="nimrodfixel"
DOCKER_PASSWORD="nimrodfixel123"
IMAGE_NAME="radicale"

# Dynamic build versions for Docker images
VERSIONS=("latest" "stable" "test")
BUILD_VERSIONS=("3.2.3" "3.2.2" "master")

# Dynamic build ports for k8s services
PORTS=("5232" "5233" "5234")

# Function to login to DockerHub using the hardcoded username and password
login_to_docker() {
    echo "Logging into Docker Hub with hardcoded credentials..."
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin >> /dev/null
    if [ $? -eq 0 ]; then
        echo "DockerHub login successful!"
    else
        echo "DockerHub login failed! Please check your credentials."
        exit 1
    fi
    sleep 2
}

# Function to build and push Docker images
build_and_push() {
    local version=$1
    local build_arg=$2

    mkdir -p config  # Ensure the config directory exists
    echo "radicale:$(openssl passwd -apr1 'nimrodfixel123')" > config/htpasswd

    # Build and push Docker image to DockerHub
    echo "Building and pushing Docker image for version $version..."
    docker build -f Dockerfile -t $DOCKER_USERNAME/$IMAGE_NAME:$version --build-arg VERSION=$build_arg . --no-cache
    docker push $DOCKER_USERNAME/$IMAGE_NAME:$version

    if [ $? -eq 0 ]; then
        echo "Docker image $version built and pushed successfully!"
    else
        echo "Failed to build or push Docker image $version."
        exit 1
    fi

    rm -rf config/htpasswd
}

# Function to deploy Kubernetes resources for each version
deploy_kubernetes_resources() {
    local version=$1
    local port=$2

    # Replace placeholders in template files with actual version, username, and port
    sed "s/{{V_PH}}/${version}/g; s/{{DOCKER_USER}}/${DOCKER_USERNAME}/g; s/{{P_PH}}/${port}/g" k8s_templates/deployment_tmp.yaml > k8s/deployment.yaml
    sed "s/{{V_PH}}/${version}/g; s/{{P_PH}}/${port}/g" k8s_templates/service_tmp.yaml > k8s/service.yaml
    sed "s/{{V_PH}}/${version}/g; s/{{P_PH}}/${port}/g" k8s_templates/ingress_tmp.yaml > k8s/ingress.yaml

    # Apply Kubernetes resources
    echo "Deploying version $version on port $port..."
    kubectl apply -f ./k8s/pv.yaml
    kubectl apply -f ./k8s/pvc.yaml
    kubectl apply -f ./k8s/service.yaml
    kubectl apply -f ./k8s/ingress.yaml
    kubectl apply -f ./k8s/deployment.yaml
    echo "Deployment of version $version completed!"

    # Clean up temporary files
    sleep 2
    rm -rf k8s/deployment.yaml k8s/service.yaml k8s/ingress.yaml
}

# Main function to orchestrate the process
main() {
    login_to_docker

    # Build and push all versions
    for i in "${!VERSIONS[@]}"; do
        build_and_push "${VERSIONS[$i]}" "${BUILD_VERSIONS[$i]}"
    done

    # Deploy all Kubernetes resources for each version
    for i in "${!VERSIONS[@]}"; do
        deploy_kubernetes_resources "${VERSIONS[$i]}" "${PORTS[$i]}"
    done
}

main
