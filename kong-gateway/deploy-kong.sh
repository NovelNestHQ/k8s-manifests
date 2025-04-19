#!/bin/bash

set -e

echo "🔄 Creating the Kong Postgres Database..."
kubectl apply -f ./postgres-kong.yaml
echo "⏳ Waiting for Kong DB pod to be ready..."
kubectl wait --for=condition=Ready pod -l app=kong-database --timeout=120s
echo "✅ Kong DB is ready."

echo "📦 Applying Kong migrations..."
kubectl apply -f ./kong-migrations.yaml
echo "⏳ Waiting for Kong migrations to complete..."
kubectl wait --for=condition=Complete job/kong-migrations --timeout=120s || true
echo "✅ Kong migrations completed."

echo "🚀 Deploying Kong Gateway..."
kubectl apply -f ./kong.yaml
echo "⏳ Waiting for Kong Gateway pod to be ready..."
kubectl wait --for=condition=Ready pod -l app=kong --timeout=120s
echo "✅ Kong Gateway is running."

echo "🧾 Creating Kong ConfigMap..."
kubectl apply -f ./kong-config.yaml
echo "⏳ Waiting for Kong ConfigMap to be created..."
echo "✅ Kong ConfigMap created."

echo "⚙️ Applying Kong Configurator..."
kubectl apply -f ./kong-configurator.yaml
echo "⏳ Waiting for Kong Configurator pod to complete..."
kubectl wait --for=condition=Complete job/kong-configurator --timeout=120s || true
echo "✅ Kong Configurator completed."
echo ""
echo "✅ Kong Gateway is fully deployed and configured."

# echo "🌐 Port forwarding Kong Gateway ports (8000, 8001, 8002)..."
# kubectl port-forward service/kong 8000:8000 8001:8001 8002:8002

