# Terraform - Azure Infrastructure

Infraestrutura como código para provisionar recursos Azure do projeto Conduit.

## Recursos Provisionados

### Compute (VMs)
- **vm-docker**: VM para rodar backend em Docker (Standard_D2s_v3)
- **vm-ci**: VM para CI/CD (Standard_D2s_v3)
- Network Security Group com regras para SSH, HTTP, HTTPS

### Kubernetes (AKS)
- **aks-conduit**: Cluster Kubernetes
- 2 nodes workers (Standard_D2as_v4)
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
# IPs públicos das VMs
terraform output docker_vm_public_ip
terraform output ci_vm_public_ip

# Cluster AKS
terraform output aks_cluster_name

# Conectar ao AKS
az aks get-credentials --resource-group rg-conduit-devops --name aks-conduit

# PostgreSQL
terraform output postgres_server_fqdn
terraform output postgres_database_name
```

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