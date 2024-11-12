# NGINX Deployment on Amazon EKS

This guide provides instructions for deploying an NGINX web server on an Amazon EKS (Elastic Kubernetes Service) cluster using Kubernetes. The setup includes:

- A Deployment that runs an NGINX container.
- A Service that exposes the NGINX Deployment via an external LoadBalancer.

## Prerequisites

1. **Amazon EKS Cluster**: Ensure you have a functional EKS cluster.
2. **kubectl Configured**: `kubectl` should be configured to interact with your EKS cluster.
3. **IAM Permissions**: Ensure the necessary IAM permissions are set up for deploying resources on EKS.
4. **AWS CLI Installed**: `awscli` should be configured with credentials to access your AWS account.

## Step 1: Deploy NGINX on EKS

1. Run the following commands to apply the configuration files:

    ```bash
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    ```

2. Verify that the NGINX deployment and service are running:

    ```bash
    kubectl get deployments
    kubectl get services
    ```

## Step 2: Access the NGINX Web Server

1. After applying the `service.yaml`, Kubernetes will create an external load balancer. Run the following command to get the external IP address:

    ```bash
    kubectl get svc nginx-service
    ```

2. Copy the `EXTERNAL-IP` and open it in a web browser to verify that the NGINX web server is accessible.

## Cleanup

To remove the resources from your EKS cluster:

```bash
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
