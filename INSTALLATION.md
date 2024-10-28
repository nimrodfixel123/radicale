
# Installation Guide

## Prerequisites
Before you begin, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/) - Container platform.
- [K3s](https://k3s.io/) - Lightweight Kubernetes or [K8S](https://kubernetes.io/) - Full Kubernetes.
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - Kubernetes CLI.

# Step-by-Step Installation
## 1. Setup K3s/K8s:
### K3s
   - curl -L get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -
   - export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
   - Follow: https://docs.k3s.io/installation/
### K8s
   - [Linux]   Follow: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
   - [macOS]   Follow: https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/
   - [Windows] Follow: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/

## 2. Run setup installation script:
[`Setup Documentation`](SETUP.md)
```bash
chmod +x setup.sh
./setup.sh
```
This script will:
- Log in to DockerHub with your credentials.
- Build and push Docker images for Radicale.
- Deploy Kubernetes resources for all versions (`latest`, `stable`, and `test`).



## 3. Access Radicale:
- Latest: http://[host-ip]:5232
- Stable: http://[host-ip]:5233
- Test: http://[host-ip]:5234

## 4. To clean up (remove Kubernetes resources), use the `delete.sh` script:
[`Delete Documentation`](DELETE.md)
```bash
chmod +x delete.sh
./delete.sh
```
