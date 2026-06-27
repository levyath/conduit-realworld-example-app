#!/bin/bash

# Script para deploy Kubernetes local (após terraform apply)
# Uso: ./deploy-k8s-local.sh

set -e

echo "=========================================="
echo "Deploy Kubernetes - Conduit Application"
echo "=========================================="

# Verificar se está na raiz do projeto
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Execute este script da raiz do projeto"
    exit 1
fi

# Verificar dependências
echo "🔍 Verificando dependências..."
command -v gcloud >/dev/null 2>&1 || { echo "❌ gcloud não instalado"; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "❌ kubectl não instalado"; exit 1; }
command -v ansible >/dev/null 2>&1 || { echo "❌ ansible não instalado"; exit 1; }

# Obter valores do Terraform
echo ""
echo "📊 Obtendo outputs do Terraform..."
cd infra/terraform

if [ ! -f "terraform.tfstate" ]; then
    echo "❌ Execute 'terraform apply' primeiro!"
    exit 1
fi

DB_HOST=$(terraform output -raw db_public_ip)
GKE_CLUSTER=$(terraform output -raw gke_cluster_name)

cd ../..

echo "✅ DB Host: $DB_HOST"
echo "✅ GKE Cluster: $GKE_CLUSTER"

# Verificar secrets
echo ""
echo "🔐 Verificando secrets necessários..."

read -p "Digite o DB_USER [conduit_user]: " DB_USER
DB_USER=${DB_USER:-conduit_user}

read -sp "Digite o DB_PASSWORD [PostgreSQL@2026!Conduit]: " DB_PASSWORD
echo
DB_PASSWORD=${DB_PASSWORD:-PostgreSQL@2026!Conduit}

read -sp "Digite o JWT_KEY: " JWT_KEY
echo
if [ -z "$JWT_KEY" ]; then
    JWT_KEY="conduit-jwt-secret-key-$(date +%s)"
    echo "⚠️  JWT_KEY gerado automaticamente: $JWT_KEY"
fi

# Configurar kubectl
echo ""
echo "⚙️  Configurando kubectl com GKE..."
gcloud container clusters get-credentials $GKE_CLUSTER \
    --region us-central1 \
    --project project-75d2944a-cedf-48bb-815

# Instalar collection Ansible se necessário
echo ""
echo "📦 Instalando Ansible Kubernetes collection..."
ansible-galaxy collection install kubernetes.core --force

# Exportar variáveis de ambiente
export GKE_CLUSTER_NAME=$GKE_CLUSTER
export GCP_PROJECT="project-75d2944a-cedf-48bb-815"
export GCP_REGION="us-central1"
export DB_USER=$DB_USER
export DB_PASSWORD=$DB_PASSWORD
export DB_HOST=$DB_HOST
export JWT_KEY=$JWT_KEY

# Executar playbook Ansible
echo ""
echo "🚀 Executando deploy Kubernetes via Ansible..."
cd infra/ansible
ansible-playbook playbooks/deploy-k8s.yml

# Verificar deploy
echo ""
echo "✅ Deploy concluído!"
echo ""
echo "🔍 Verificando pods..."
kubectl get pods -n conduit-prod

echo ""
echo "🔍 Verificando services..."
kubectl get svc -n conduit-prod

echo ""
echo "🌐 Obtendo IP do Gateway..."
GATEWAY_IP=$(kubectl get svc gateway-service -n conduit-prod -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "Aguardando...")

if [ "$GATEWAY_IP" != "Aguardando..." ]; then
    echo ""
    echo "=========================================="
    echo "✅ APLICAÇÃO DISPONÍVEL EM:"
    echo "   http://$GATEWAY_IP"
    echo "=========================================="
else
    echo ""
    echo "⏳ LoadBalancer ainda provisionando IP..."
    echo "Execute: kubectl get svc gateway-service -n conduit-prod -w"
fi

echo ""
echo "📋 Comandos úteis:"
echo "  kubectl get pods -n conduit-prod"
echo "  kubectl get svc -n conduit-prod"
echo "  kubectl get hpa -n conduit-prod"
echo "  kubectl logs -f <pod-name> -n conduit-prod"
