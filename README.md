# Radicale Setup Using Docker & Kubernetes

This project sets up an auto-scaled calendar application using Radicale, Docker, and Kubernetes (K3s/K8s). The app supports multiple versions (`latest`, `stable`, and `test`), each deployed with persistent volumes and Kubernetes services.

## Features:
- Dynamic Docker image creation for Radicale versions.
- Kubernetes deployment with resource management (persistent volumes, services, and ingress for external access).
- Fully automated with interactive Bash scripts.

## Usage:
1. **Installation**:
   Follow the installation instructions in [`INSTALLATION.md`](INSTALLATION.md).

2. **Setup**:
   Run the setup script to build Docker images and deploy Kubernetes resources.
   ```bash
   ./setup.sh
   ```

3. **Delete Kubernetes Resources**:
   To clean up all Kubernetes deployments, use the `delete.sh` script.
   ```bash
   ./delete.sh
   ```