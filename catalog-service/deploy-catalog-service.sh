#!/bin/bash

set -e

echo "🚀 Deploying MongoDB for Catalog Service..."
kubectl apply -f mongodb-catalog.yaml
echo "⏳ Waiting for mongodb pod to be ready..."
kubectl wait --for=condition=ready pod -l app=mongodb --timeout=90s
echo "✅ MongoDB is ready."

echo "🚀 Deploying Catalog Service..."
kubectl apply -f catalog-service.yaml
echo "⏳ Waiting for catalog-service pod to be ready..."
kubectl wait --for=condition=ready pod -l app=catalog-service --timeout=90s
echo "✅ Catalog Service is running."
