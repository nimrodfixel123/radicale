#!/bin/bash

set -o errexit  # Exit on any command failing
set -o pipefail # Return non-zero status if any part of a pipeline fails

# Versions and ports used for deployment
VERSIONS=("latest" "stable" "test")
PORTS=("5232" "5233" "5234")

# Docker Hub username
DOCKER_USERNAME="nimrodfixel"

# Function to check if a Kubernetes resource exists
check_resource_exists() {
    kubectl get "$1" "$2" &>/dev/null
    return $?
}

# Function to delete Kubernetes resources
delete_kubernetes_resources() {
    local version=$1
    local port=$2

    echo "Deleting Kubernetes resources for version $version..."

    # Replace placeholders in template files with actual version, port, and DockerHub username
    sed "s/{{V_PH}}/${version}/g; s/{{P_PH}}/${port}/g; s/{{DOCKER_USER}}/${DOCKER_USERNAME}/g" k8s_templates/deployment_tmp.yaml > k8s/deployment.yaml
    sed "s/{{V_PH}}/${version}/g; s/{{P_PH}}/${port}/g" k8s_templates/service_tmp.yaml > k8s/service.yaml
    sed "s/{{V_PH}}/${version}/g; s/{{P_PH}}/${port}/g" k8s_templates/ingress_tmp.yaml > k8s/ingress.yaml

    # Delete Kubernetes resources
    if check_resource_exists "deployment" "radicale-deployment-${version}"; then
        kubectl delete -f ./k8s/deployment.yaml --force --grace-period=0 || { echo "Error deleting deployment for version $version"; }
    else
        echo "Deployment for version $version not found, skipping."
    fi

    if check_resource_exists "svc" "radicale-service-${version}"; then
        kubectl delete -f ./k8s/service.yaml --force --grace-period=0 || { echo "Error deleting service for version $version"; }
    else
        echo "Service for version $version not found, skipping."
    fi

    if check_resource_exists "ingress" "radicale-ingress-${version}"; then
        kubectl delete -f ./k8s/ingress.yaml --force --grace-period=0 || { echo "Error deleting ingress for version $version"; }
    else
        echo "Ingress for version $version not found, skipping."
    fi

    # Delete persistent volumes and claims
    kubectl delete -f ./k8s/pv.yaml --force --grace-period=0 || { echo "Error deleting persistent volume for version $version"; }
    kubectl delete -f ./k8s/pvc.yaml --force --grace-period=0 || { echo "Error deleting persistent volume claim for version $version"; }

    echo "Cleanup of version $version completed!"

    # Clean up temporary files
    rm -rf k8s/deployment.yaml k8s/service.yaml k8s/ingress.yaml
}

# Loop through all versions and delete their respective resources
for i in "${!VERSIONS[@]}"; do
    delete_kubernetes_resources "${VERSIONS[$i]}" "${PORTS[$i]}"
done
