#!/bin/bash

set -e

echo "📦 Starting NovelNest Deployment..."

echo ""
echo "======================================================"
echo "📦 Step 0: Setting up Kubernetes Namespace..."
kubectl create namespace novelnest || echo "Namespace 'novelnest' already exists."
echo "✅ Namespace 'novelnest' is ready."
echo "Setting context to 'novelnest'..."
kubectl config set-context --current --namespace=novelnest
echo "✅ Context set to 'novelnest'."
echo "======================================================"

echo ""
echo "======================================================"
echo "🔐 Step 1: Deploying Kong Gateway and RabbitMQ..."
echo "======================================================"
echo "🐰 Deploying RabbitMQ..."
kubectl apply -f ./rabbitmq.yaml
echo "⏳ Waiting for RabbitMQ pod to be ready..."
kubectl wait --for=condition=ready pod -l app=rabbitmq --timeout=90s
echo "✅ RabbitMQ is ready."
cd kong-gateway
./deploy-kong.sh

echo ""
echo "======================================================"
echo "👤 Step 2: Deploying User Service..."
echo "======================================================"
cd ../user-service
./deploy-user-service.sh

echo ""
echo "======================================================"
echo "📦 Step 3: Deploying Catalog Service..."
echo "======================================================"
cd ../catalog-service
./deploy-catalog-service.sh

echo ""
echo "======================================================"
echo "📚 Step 4: Deploying Inventory Service..."
echo "======================================================"
cd ../inventory-service
./deploy-inventory-service.sh

echo ""
echo "======================================================"
echo "🧾 Step 5: Deploying Order Service..."
echo "======================================================"
cd ../order-service
./deploy-order-service.sh

echo ""
echo "======================================================"
echo "📦 Step 6: Deploying NovelNest UI..."
echo "======================================================"
cd ..
kubectl apply -f ./novelnest-ui.yaml
echo "⏳ Waiting for NovelNest UI pod to be ready..."
kubectl wait --for=condition=ready pod -l app=novelnest-ui --timeout=90s
echo "✅ NovelNest UI is running."
echo ""
echo "======================================================"
echo "✅ All services deployed successfully! 🎉🎉"
echo "======================================================"

echo ""
echo "================================================================================="
echo "🔗 To access the application locally:"
echo "================================================================================="
echo "1️⃣  Port-forward the NovelNest UI:"
echo "   kubectl port-forward svc/novelnest-ui 5173:5173 -n novelnest &"
echo ""
echo "2️⃣  Port Forward Kong Admin & Proxy Ports:"
echo "   kubectl port-forward service/kong 8000:8000 8001:8001 8002:8002 -n novelnest &"
echo ""
echo "3️⃣  Access the NovelNest UI in your browser at: http://localhost:5173"
echo ""
echo "4️⃣  Access the Kong Gateway Dashboard at: http://localhost:8002"
echo ""
echo "================================================================================="

