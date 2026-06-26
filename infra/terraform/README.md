# Terraform - Azure Infrastructure

Infraestrutura como código para provisionar recursos Azure do projeto Conduit.

## Recursos Provisionados

### Compute (VM)
- **vm-app**: VM única para Docker e CI/CD (Standard_D2s_v3)
  - *Nota*: Docker e CI foram combinados na mesma VM devido a limitações de quota da conta Azure
- Network Security Group com regras para SSH, HTTP, HTTPS

### Kubernetes (AKS)
- **aks-conduit**: Cluster Kubernetes
- 1 node worker (Standard_D2as_v4)
  - *Nota*: Reduzido para 1 node devido a limitações de quota da conta Azure
- Network plugin: Azure CNI
- Network policy: Calico

### Database (PostgreSQL)
- **psql-conduit**: Azure Database for PostgreSQL Flexible Server
- Versão 16
- SKU: B_Standard_B1ms
- Storage: 32GB
- Database: conduit_development

### Network
- Virtual Network: 10.0.0.0/16
- Subnet VMs: 10.0.1.0/24
- Subnet AKS: 10.0.2.0/24

## Pré-requisitos

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- Conta Azure ativa

## Configuração

### 1. Login no Azure

```bash
az login
```

### 2. Criar arquivo de variáveis

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edite o arquivo `terraform.tfvars` com suas senhas:

```hcl
admin_password = "SuaSenhaSegura123!"
postgres_admin_password = "SuaSenhaBanco123!"
```

### 3. Inicializar Terraform

```bash
terraform init
```

### 4. Validar configuração

```bash
terraform validate
terraform fmt
```

### 5. Planejar infraestrutura

```bash
terraform plan
```

### 6. Aplicar infraestrutura

```bash
terraform apply
```

## Outputs

Após o apply, você terá acesso a:

```bash
# IP público da VM
terraform output app_vm_public_ip

# Cluster AKS
terraform output aks_cluster_name

# Conectar ao AKS
az aks get-credentials --resource-group rg-conduit-devops --name aks-conduit

# PostgreSQL
terraform output postgres_server_fqdn
terraform output postgres_database_name
```

## Justificativa da Arquitetura

Devido a limitações de quota na conta Azure utilizada, a infraestrutura foi otimizada:

- **1 VM** (Standard_D2s_v3) combina Docker e CI/CD
- **AKS com 1 node** (Standard_D2as_v4) ao invés de 2

Esta configuração mantém todos os requisitos funcionais do projeto, com recursos consolidados para adequação aos limites da conta.

## Destruir infraestrutura

```bash
terraform destroy
```

## Estrutura de módulos

```
terraform/
├── main.tf                    # Configuração principal
├── variables.tf               # Variáveis
├── outputs.tf                 # Outputs
├── terraform.tfvars.example   # Exemplo de variáveis
└── modules/
    ├── compute/              # Módulo VMs
    ├── kubernetes/           # Módulo AKS
    └── database/             # Módulo PostgreSQL
```