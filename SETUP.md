
# Setup Documentation

## Overview
This setup script automates the deployment and management of **Radicale** using **Docker** and **Kubernetes**.
It simplifies tasks such as:
- Building and pushing Docker images for multiple versions (latest, stable, test).
- Deploying Kubernetes resources for each version with persistent volume support.

## Key Features
- **Docker image management**: Builds and pushes images for all Radicale versions to DockerHub.
- **Kubernetes deployment**: Deploys each version of Radicale with its own service, ingress, and persistent volume.

## Steps for Running:
1. **Run setup script**:
   ```bash
   ./setup.sh
   ```
   This will build, push Docker images, and deploy Kubernetes resources for the default versions (`latest`, `stable`, `test`).

2. **Custom versions**:
   You can specify custom versions:
   ```bash
   ./setup.sh "latest_version" "stable_version" "test_version"
   ```

3. **Remove Kubernetes resources**:
   Use the `delete.sh` script to remove all Kubernetes resources.
   ```bash
   ./delete.sh
   ```

   For more information on deletion, check the `DELETE.md` documentation.