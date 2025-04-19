#!/bin/bash

set -e

echo "⏳ Applying Inventory Postgres resources..."
kubectl apply -f postgres-inventory.yaml
echo "✅ Waiting for Postgres to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres-inventory --timeout=90s
echo "✅ Postgres is ready."

echo "🚀 Running Prisma migrate Job..."
kubectl apply -f inventory-service-migrations.yaml
echo "✅ Waiting for Prisma migrate Job to complete..."
kubectl wait --for=condition=complete job/inventory-prisma-migrate --timeout=90s
echo "✅ Prisma migration completed."

echo "📦 Deploying Inventory Service..."
kubectl apply -f inventory-service.yaml
echo "✅ Waiting for Inventory Service to be ready..."
kubectl rollout status deployment/inventory-service
echo "🚀 Inventory Service successfully deployed!"
