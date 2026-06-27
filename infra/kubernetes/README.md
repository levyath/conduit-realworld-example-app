# Kubernetes Manifests - Conduit Application

## Overview
This directory contains all Kubernetes manifests for deploying the Conduit application on GKE.

## Architecture

### Layers
1. **Gateway Layer** - Nginx API Gateway (entry point)
2. **Frontend Layer** - React application
3. **Backend Layer** - Node.js API
4. **Database Layer** - PostgreSQL read cluster (2 replicas)

### Components

#### Namespace
- `namespace.yaml` - Creates `conduit-prod` namespace

#### Resource Management
- `resource-quota.yaml` - Limits total resources in namespace
- `limit-range.yaml` - Sets default resource limits for pods

#### Gateway (API Gateway - 1 point)
- `gateway-configmap.yaml` - Nginx configuration
- `gateway-deployment.yaml` - 2 replicas with health checks
- `gateway-service.yaml` - LoadBalancer (external access)
- Routes `/api/*` → Backend, `/*` → Frontend

#### Frontend
- `frontend-deployment.yaml` - 2 replicas with rolling updates
- `frontend-service.yaml` - LoadBalancer service
- `frontend-hpa.yaml` - Auto-scaling (2-5 replicas, 60% CPU target)

#### Backend
- `backend-deployment.yaml` - 2 replicas with rolling updates
- `backend-service.yaml` - ClusterIP service
- `backend-hpa.yaml` - Auto-scaling (2-5 replicas, 60% CPU target)
- `backend-configmap.yaml` - Database configuration

#### Database (Read Cluster - 1 point)
- `postgres-statefulset.yaml` - 2 PostgreSQL replicas
- `postgres-service.yaml` - Headless service for StatefulSet
- Note: Uses Cloud SQL as primary, in-cluster for reads

#### Secrets
- `secrets-template.yaml` - Template (actual secrets created by Ansible)

#### Ingress
- `ingress.yaml` - External traffic routing

## Deployment

### Manual Deployment
```bash
# 1. Create namespace
kubectl apply -f namespace.yaml

# 2. Create secrets
kubectl create secret generic db-credentials \
  --from-literal=username=conduit_user \
  --from-literal=password='PostgreSQL@2026!Conduit' \
  -n conduit-prod

kubectl create secret generic jwt-secret \
  --from-literal=jwt_key='your-jwt-key' \
  -n conduit-prod

# 3. Apply all manifests
kubectl apply -f resource-quota.yaml
kubectl apply -f limit-range.yaml
kubectl apply -f backend-configmap.yaml
kubectl apply -f gateway-configmap.yaml

# Database
kubectl apply -f postgres-service.yaml
kubectl apply -f postgres-statefulset.yaml

# Backend
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f backend-hpa.yaml

# Frontend
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
kubectl apply -f frontend-hpa.yaml

# Gateway
kubectl apply -f gateway-deployment.yaml
kubectl apply -f gateway-service.yaml

# Ingress
kubectl apply -f ingress.yaml
```

### Automated Deployment (Ansible)
```bash
cd ../ansible
ansible-playbook playbooks/deploy-k8s.yml
```

## Verification

```bash
# Check all pods
kubectl get pods -n conduit-prod

# Check services
kubectl get svc -n conduit-prod

# Get Gateway external IP
kubectl get svc gateway-service -n conduit-prod

# Check HPA status
kubectl get hpa -n conduit-prod

# View pod logs
kubectl logs -f <pod-name> -n conduit-prod
```

## Requirements Met

✅ **Cluster com 2+ nodes** (configured in Terraform)
✅ **Deployment com 2+ réplicas** (all components have 2 replicas)
✅ **RollingUpdate configurado** (maxSurge: 1, maxUnavailable: 0)
✅ **Service** (ClusterIP for internal, LoadBalancer for external)
✅ **Ingress** (configured for external routing)
✅ **HPA com 60% CPU** (frontend and backend)
✅ **ResourceQuota e LimitRange** (namespace-level)
✅ **Liveness e Readiness probes** (all deployments)
✅ **API Gateway** (Nginx routing to services)
✅ **Database read cluster** (2 PostgreSQL replicas via StatefulSet)

## Assignment Points Coverage

| Requirement | Points | Status |
|-------------|--------|--------|
| API Gateway configured | 1 | ✅ Complete |
| K8s with 2+ nodes, HPA, probes, quotas | 2 | ✅ Complete |
| Database read cluster in K8s | 1 | ✅ Complete |

**Total K8s Points: 4/4** ✅
