# Delete Kubernetes Resources

The `delete.sh` script removes all Kubernetes resources created for the Radicale application. This includes deployments, services, ingress, and persistent volumes.

## How to Use:
1. Make the script executable:
   ```bash
   chmod +x delete.sh
   ```

2. Run the script:
   ```bash
   ./delete.sh
   ```

This will:
- Delete deployments, services, and ingresses for `latest`, `stable`, and `test` versions.
- Clean up persistent volumes and volume claims.

If you encounter any issues, ensure that the Kubernetes cluster is running and that the resources exist.
