# NovelNest Kubernetes Manifests

This repository contains Kubernetes manifests for deploying the NovelNest application - a microservices-based online bookstore platform - to a Kubernetes cluster.

## 📖 Project Overview

NovelNest is an online bookstore application that allows users to browse a catalog of books, manage inventory, place orders, and authenticate users. The application is built using a microservices architecture, with each service responsible for a specific domain.

## 🏗️ Architecture Overview

The NovelNest application consists of the following components, all deployed via Kubernetes:

| Component | Description | Database |
|-----------|-------------|----------|
| Frontend UI | Web interface for the NovelNest application | - |
| User Service | Handles user authentication and management | PostgreSQL |
| Catalog Service | Manages the book catalog and details | MongoDB |
| Inventory Service | Manages book inventory and stock levels | PostgreSQL |
| Order Service | Processes customer orders | PostgreSQL |
| Kong API Gateway | Routes and manages API traffic to backend services | PostgreSQL |
| RabbitMQ | Message broker for service-to-service communication | - |

## 🛠️ Prerequisites

Before you begin, ensure you have the following tools installed:

- [kubectl](https://kubernetes.io/docs/tasks/tools/) - Kubernetes command-line tool
- A Kubernetes cluster, you can use one of the following:
  - [Minikube](https://minikube.sigs.k8s.io/docs/start/) - Local Kubernetes cluster
  - [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) - Kubernetes in Docker
  - Cloud-based Kubernetes (GKE, EKS, AKS)
- [Docker](https://docs.docker.com/get-docker/) - Container runtime
- [Git](https://git-scm.com/downloads) - Version control

## 🚀 Installation / Usage Instructions

### Clone the Repository

```bash
git clone https://github.com/your-username/NovelNestHQ.git
cd NovelNestHQ/k8s-manifests
```

### Using the Automated Deployment Script

The easiest way to deploy NovelNest is using the provided deployment script:

```bash
chmod +x deploy-all.sh
./deploy-all.sh
```

This script will:
1. Create a 'novelnest' namespace if it doesn't exist
2. Deploy Kong API Gateway and RabbitMQ
3. Deploy User Service with its database
4. Deploy Catalog Service with its database
5. Deploy Inventory Service with its database
6. Deploy Order Service with its database
7. Deploy the NovelNest UI

### Manual Deployment

If you prefer to deploy components individually, follow these steps:

1. Create the Kubernetes namespace:
   ```bash
   kubectl create namespace novelnest
   kubectl config set-context --current --namespace=novelnest
   ```

2. Deploy RabbitMQ:
   ```bash
   kubectl apply -f ./rabbitmq.yaml
   ```

3. Deploy Kong Gateway:
   ```bash
   cd kong-gateway
   ./deploy-kong.sh
   cd ..
   ```

4. Deploy User Service:
   ```bash
   cd user-service
   ./deploy-user-service.sh
   cd ..
   ```

5. Deploy Catalog Service:
   ```bash
   cd catalog-service
   ./deploy-catalog-service.sh
   cd ..
   ```

6. Deploy Inventory Service:
   ```bash
   cd inventory-service
   ./deploy-inventory-service.sh
   cd ..
   ```

7. Deploy Order Service:
   ```bash
   cd order-service
   ./deploy-order-service.sh
   cd ..
   ```

8. Deploy NovelNest UI:
   ```bash
   kubectl apply -f ./novelnest-ui.yaml
   ```

## 🌐 Accessing the Application

After deployment, you can access the NovelNest application using port-forwarding:

```bash
# Forward the frontend UI
kubectl port-forward svc/novelnest-ui 5173:5173 -n novelnest &

# Forward Kong API Gateway
kubectl port-forward service/kong 8000:8000 8001:8001 8002:8002 -n novelnest &
```

Then you can access:
- NovelNest UI: http://localhost:5173
- Kong Gateway Dashboard: http://localhost:8002
- API Endpoints via Kong: http://localhost:8000

## 📁 Folder Structure

```
k8s-manifests/
├── deploy-all.sh           # Main deployment script
├── novelnest-ui.yaml       # Frontend UI deployment
├── rabbitmq.yaml           # RabbitMQ message broker
├── catalog-service/        # Catalog service manifests
│   ├── catalog-service.yaml
│   ├── deploy-catalog-service.sh
│   └── mongodb-catalog.yaml
├── inventory-service/      # Inventory service manifests
│   ├── deploy-inventory-service.sh
│   ├── inventory-service-migrations.yaml
│   ├── inventory-service.yaml
│   └── postgres-inventory.yaml
├── kong-gateway/           # API Gateway manifests
│   ├── deploy-kong.sh
│   ├── kong-config.yaml
│   ├── kong-configurator.yaml
│   ├── kong-migrations.yaml
│   ├── kong.yaml
│   └── postgres-kong.yaml
├── order-service/          # Order service manifests
│   ├── deploy-order-service.sh
│   ├── order-service-migrations.yaml
│   ├── order-service.yaml
│   └── postgres-order.yaml
└── user-service/           # User service manifests
    ├── deploy-user-service.sh
    ├── postgres-auth.yaml
    ├── postgres-user.yaml
    ├── supertokens-admin-create.yaml
    ├── supertokens.yaml
    ├── user-service-migrations.yaml
    └── user-service.yaml
```

## 🧹 Cleanup Instructions

To remove all resources created by this deployment:

```bash
# Delete all resources in the novelnest namespace
kubectl delete namespace novelnest

# Or, to delete specific resources without deleting the namespace
kubectl delete -f novelnest-ui.yaml -n novelnest
kubectl delete -f rabbitmq.yaml -n novelnest
kubectl delete -f ./user-service/ -n novelnest
kubectl delete -f ./catalog-service/ -n novelnest
kubectl delete -f ./inventory-service/ -n novelnest
kubectl delete -f ./order-service/ -n novelnest
kubectl delete -f ./kong-gateway/ -n novelnest
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Troubleshooting

If you encounter issues during deployment:

1. Check pod status:
   ```bash
   kubectl get pods -n novelnest
   ```

2. Check pod logs:
   ```bash
   kubectl logs <pod-name> -n novelnest
   ```

3. Verify service endpoints:
   ```bash
   kubectl get endpoints -n novelnest
   ```

4. Ensure all services are running:
   ```bash
   kubectl get svc -n novelnest
   ```
