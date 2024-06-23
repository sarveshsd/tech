#!/bin/bash

# Function to check if pod is running
pod_is_running() {
  local pod_name=$1
  local namespace=$2
  kubectl get pod "$pod_name" -n "$namespace" -o jsonpath='{.status.phase}' | grep -q 'Running'
}

# Port forwarding commands
kubectl port-forward --address 0.0.0.0 svc/frontend 3000:80 &
kubectl port-forward --address 0.0.0.0 svc/backend 8080:8080 &
kubectl port-forward --address 0.0.0.0 svc/postgres 5432:5432 &

# Wait for pods to be running before proceeding
while ! pod_is_running frontend YOUR_NAMESPACE && ! pod_is_running backend YOUR_NAMESPACE && ! pod_is_running postgres YOUR_NAMESPACE; do
  echo "Waiting for pods to be running..."
  sleep 10
done

# Once all pods are running, proceed with port forwarding
wait
