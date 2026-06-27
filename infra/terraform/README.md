# Terraform - Google Cloud Platform (GCP)

Infraestrutura como Código para o projeto Conduit usando Google Cloud Platform.

## 📋 Recursos Provisionados

### 🖥️ Compute Engine
- **1 VM e2-standard-2** (2 vCPUs, 8 GB RAM)
- Docker + Docker Compose pré-instalado
- CI/CD Runner (GitHub Actions)
- 50 GB de disco

### ☸️ Google Kubernetes Engine (GKE)
- **Cluster regional** com 1-3 nodes
- Nodes e2-standard-2 (auto-scaling)
- Workload Identity habilitado
- Load Balancer integrado

### 🗄️ Cloud SQL
- **PostgreSQL 15**
- Instância db-f1-micro
- Backups automáticos diários
- Point-in-time recovery (7 dias)

### 🌐 Networking
- VPC customizada
- Subnets separadas (VMs e GKE)
- Firewall rules (SSH, HTTP, HTTPS)
- IP ranges secundários para pods/services

## 🚀 Guia Rápido (15 minutos)

### 1. Instalar gcloud CLI

**Windows:**
```bash
choco install gcloudsdk
```

**Linux/macOS:**
```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
```

### 2. Configurar GCP

```bash
# Login
gcloud auth login

# Configurar projeto
gcloud init

# Ativar APIs
gcloud services enable compute.googleapis.com container.googleapis.com sqladmin.googleapis.com
```

### 3. Gerar chave SSH (se não tiver)

```bash
ssh-keygen -t rsa -b 4096 -C "gcp@conduit"
# Salvar em: ~/.ssh/id_rsa
```

### 4. Configurar variáveis

```bash
# Editar terraform.tfvars
# Alterar:
# - project_id (obter com: gcloud config get-value project)
# - db_admin_password
```

### 5. Provisionar

```bash
terraform init
terraform plan
terraform apply
# Digite: yes
```

⏱️ **Aguarde 10-15 minutos...**

### 6. Configurar kubectl

```bash
# Comando será exibido no output
gcloud container clusters get-credentials gke-conduit-frontend --region us-central1
kubectl get nodes
```

### 7. Configurar Secrets GitHub

Pegue os valores dos outputs e configure em: **Settings → Secrets and variables → Actions**

```
DOCKER_USERNAME
DOCKER_PASSWORD
SSH_PRIVATE_KEY       = cat ~/.ssh/id_rsa
VM_PUBLIC_IP          = (output: vm_public_ip)
DB_HOST               = (output: db_public_ip)
DB_USER               = conduit_user
DB_PASSWORD           = (mesmo do terraform.tfvars)
DB_NAME               = conduit
JWT_KEY               = openssl rand -hex 32
```

## 📤 Outputs Importantes

```bash
# Ver todos
terraform output

# Específicos
terraform output vm_public_ip
terraform output db_public_ip
terraform output gke_kubeconfig_command
```

## 🧹 Destruir Infraestrutura

```bash
terraform destroy
# Digite: yes
```

## 💰 Custos Estimados

| Recurso | Tipo | Custo/mês (US$) |
|---------|------|-----------------|
| VM (e2-standard-2) | Compute Engine | ~$50 |
| GKE (1 node) | Kubernetes | ~$50 |
| Cloud SQL (db-f1-micro) | PostgreSQL | ~$10 |
| **Total** | | **~$110/mês** |

💡 **Você tem $300 de créditos grátis no GCP!**

## 🐛 Troubleshooting

### Erro: "API not enabled"
```bash
gcloud services enable compute.googleapis.com container.googleapis.com sqladmin.googleapis.com
```

### Erro: "Permission denied (publickey)"
```bash
# Verificar se chave existe
ls ~/.ssh/id_rsa.pub

# Se não existir, gerar
ssh-keygen -t rsa -b 4096
```

### GKE não conecta
```bash
gcloud container clusters get-credentials gke-conduit-frontend --region us-central1
```

### Cloud SQL não conecta
```bash
# Testar conexão
gcloud sql connect cloudsql-conduit-postgres --user=postgres
```

## 📚 Documentação

- [Google Cloud SDK](https://cloud.google.com/sdk/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GKE Documentation](https://cloud.google.com/kubernetes-engine/docs)

---

**Pronto para provisionar!** 🚀
