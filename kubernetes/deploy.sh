#!/bin/bash
#
## Function to check if pod is running
#pod_is_running() {
#  local pod_name=$1
#  local namespace=$2
#  kubectl get pod "$pod_name" -n "$namespace" -o jsonpath='{.status.phase}' | grep -q 'Running'
#}
#
#kubectl port-forward --address 0.0.0.0 svc/frontend 3000:80 &
#kubectl port-forward --address 0.0.0.0 svc/backend 8080:8080 &
#kubectl port-forward --address 0.0.0.0 svc/postgres 5432:5432 &
#
#echo "All pods are running. Continuing with pipeline..."


#!/bin/bash

# Function to check if pod is running
pod_is_running() {
  local pod_name=$1
  local namespace=$2
  kubectl get pod "$pod_name" -n "$namespace" -o jsonpath='{.status.phase}' | grep -q 'Running'
}

# Function to wait for pods to be running
wait_for_pods() {
  local timeout_secs=60  # Timeout in seconds
  local start_time=$(date +%s)
  
  while true; do
    if pod_is_running frontend svc; then
      if pod_is_running backend svc; then
        if pod_is_running postgres svc; then
          echo "All pods are running. Continuing with pipeline..."
          return 0
        fi
      fi
    fi
    
    current_time=$(date +%s)
    elapsed_time=$((current_time - start_time))
    
    if [ $elapsed_time -ge $timeout_secs ]; then
      echo "Timeout reached. Proceeding with port-forwarding."
      return 1
    fi
    
    sleep 5  # Check every 5 seconds
  done
}

# Main script
if wait_for_pods; then
  # Start port-forwarding if pods are running
  kubectl port-forward --address 0.0.0.0 svc/frontend 3000:80 &
  kubectl port-forward --address 0.0.0.0 svc/backend 8080:8080 &
  kubectl port-forward --address 0.0.0.0 svc/postgres 5432:5432 &
else
  # Proceed with port-forwarding regardless of pod status
  echo "Starting port-forwarding without waiting for pods to be ready..."
  kubectl port-forward --address 0.0.0.0 svc/frontend 3000:80 &
  kubectl port-forward --address 0.0.0.0 svc/backend 8080:8080 &
  kubectl port-forward --address 0.0.0.0 svc/postgres 5432:5432 &
fi
