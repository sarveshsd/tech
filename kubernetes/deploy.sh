#!/bin/bash

kubectl port-forward --address 0.0.0.0 svc/frontend 3000:80 &
kubectl port-forward --address 0.0.0.0 svc/backend 8080:8080 &
kubectl port-forward --address 0.0.0.0 svc/postgres 5432:5432 &

echo "All pods are running. Continuing with pipeline..."

