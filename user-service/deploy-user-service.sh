#!/bin/bash

set -e

echo "🚀 Deploying Postgres for User Service..."
kubectl apply -f postgres-user.yaml
echo "⏳ Waiting for postgres-user pod to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres-user --timeout=90s
echo "✅ Postgres for User Service is ready."

echo "🚀 Deploying Postgres for SuperTokens..."
kubectl apply -f postgres-auth.yaml
echo "⏳ Waiting for postgres-auth pod to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres-auth --timeout=90s
echo "✅ Postgres for SuperTokens is ready."

echo "🚀 Deploying SuperTokens..."
kubectl apply -f supertokens.yaml
echo "⏳ Waiting for supertokens pod to be ready..."
kubectl wait --for=condition=ready pod -l app=supertokens-service --timeout=90s
echo "✅ SuperTokens is ready."

echo "🚀 Creating SuperTokens Admin Username and Password ..."
kubectl apply -f supertokens-admin-create.yaml
echo "⏳ Waiting for supertokens-admin-create job to complete..."
kubectl wait --for=condition=complete job/supertokens-admin-create --timeout=120s
echo "✅ SuperTokens Admin Username and Password created."

echo "🧪 Running Prisma migration job for User Service..."
kubectl apply -f user-service-migrations.yaml
echo "⏳ Waiting for Prisma migration job to complete..."
kubectl wait --for=condition=complete job/user-prisma-migrate --timeout=120s
echo "✅ Prisma migration completed."

echo "🚀 Deploying User Service..."
kubectl apply -f user-service.yaml
echo "⏳ Waiting for user-service pod to be ready..."
kubectl wait --for=condition=ready pod -l app=user-service --timeout=90s
echo "✅ User Service is running."
