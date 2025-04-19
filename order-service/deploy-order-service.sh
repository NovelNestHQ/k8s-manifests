#!/bin/bash

set -e

echo "🚀 Deploying Postgres for Order Service..."
kubectl apply -f postgres-order.yaml
echo "⏳ Waiting for postgres-order pod to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres-order --timeout=90s
echo "✅ Postgres is ready."

echo "🧪 Running Prisma migration job for Order Service..."
kubectl apply -f order-service-migrations.yaml
echo "⏳ Waiting for Prisma migration job to complete..."
kubectl wait --for=condition=complete job/order-prisma-migrate --timeout=120s
echo "✅ Prisma migration completed."

echo "🚀 Deploying Order Service..."
kubectl apply -f order-service.yaml
echo "⏳ Waiting for order-service pod to be ready..."
kubectl wait --for=condition=ready pod -l app=order-service --timeout=90s
echo "✅ Order Service is running."
