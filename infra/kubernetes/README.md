# Kubernetes Manifests

Manifestos Kubernetes para deploy do frontend do Conduit.

## Pré-requisitos

- Cluster Kubernetes com pelo menos 2 nodes workers
- kubectl configurado
- Ingress controller (nginx) instalado

## Estrutura

```
kubernetes/
├── namespace.yaml           # Namespace do projeto
├── deployment.yaml          # Deployment do frontend (2 réplicas)
├── service.yaml            # Service ClusterIP
├── ingress.yaml            # Ingress para acesso externo
├── hpa.yaml                # HorizontalPodAutoscaler (CPU 60%)
├── resource-quota.yaml     # Limites de recursos do namespace
├── limit-range.yaml        # Limites padrão para containers
└── database/
    └── statefulset-replica.yaml  # PostgreSQL com 2 pods
```

## Deploy

### 1. Criar namespace e configurações básicas

```bash
kubectl apply -f namespace.yaml
kubectl apply -f resource-quota.yaml
kubectl apply -f limit-range.yaml
```

### 2. Deploy do banco de dados

```bash
kubectl apply -f database/statefulset-replica.yaml
```

### 3. Build e carregar imagem do frontend

```bash
# Build da imagem
docker build -t conduit-frontend:latest -f infra/apis/frontend/Dockerfile .

# Se usar kind
kind load docker-image conduit-frontend:latest

# Se usar k3d
k3d image import conduit-frontend:latest

# Se usar minikube
minikube image load conduit-frontend:latest
```

### 4. Deploy do frontend

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml
kubectl apply -f ingress.yaml
```

## Verificar deploy

```bash
# Ver pods
kubectl get pods -n conduit

# Ver serviços
kubectl get svc -n conduit

# Ver ingress
kubectl get ingress -n conduit

# Ver HPA
kubectl get hpa -n conduit

# Logs do frontend
kubectl logs -n conduit -l app=conduit-frontend

# Logs do banco
kubectl logs -n conduit postgres-replica-0
```

## Acessar aplicação

Adicione no arquivo `/etc/hosts` (Linux/Mac) ou `C:\Windows\System32\drivers\etc\hosts` (Windows):

```
127.0.0.1 conduit.local
```

Acesse: http://conduit.local

## Limpar recursos

```bash
kubectl delete namespace conduit
```

## Notas

- O frontend roda com 2 réplicas por padrão
- HPA escala de 2 a 5 pods baseado em CPU (target 60%)
- PostgreSQL usa StatefulSet com 2 réplicas
- ResourceQuota limita uso total do namespace
- LimitRange define limites padrão para novos pods
