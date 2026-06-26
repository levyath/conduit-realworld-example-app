# Ansible - Deploy Automatizado

Playbooks Ansible para deploy automatizado do Conduit.

## Estrutura

```
ansible/
├── ansible.cfg              # Configuração do Ansible
├── hosts.ini               # Inventário de hosts
├── README.md              
└── playbooks/
    ├── deploy-docker.yml   # Deploy do backend em Docker
    └── deploy-k8s.yml      # Deploy do frontend em Kubernetes
```

## Pré-requisitos

- Ansible instalado (versão 2.9+)
- Acesso SSH às VMs
- Chave SSH configurada
- Docker instalado nas VMs (ou será instalado pelo playbook)
- kubectl configurado (para deploy K8s)

## Configuração

### 1. Atualizar inventário

Edite o arquivo `hosts.ini` com os IPs das suas VMs:

```ini
[docker_hosts]
20.1.2.3

[ci_hosts]
20.1.2.4
```

### 2. Configurar chave SSH

```bash
# Copiar chave SSH para as VMs
ssh-copy-id azureuser@<IP_DA_VM>
```

### 3. Testar conectividade

```bash
ansible all -m ping
```

## Playbooks

### Deploy Docker (Backend)

Faz deploy do backend em container Docker.

**O que faz:**
1. Instala Docker na VM
2. Faz login no Docker Hub
3. Pull da imagem mais recente
4. Para container antigo
5. Inicia novo container
6. Verifica status

**Executar:**

```bash
cd infra/ansible

ansible-playbook playbooks/deploy-docker.yml \
  -e "docker_username=SEU_USUARIO" \
  -e "docker_password=SUA_SENHA" \
  -e "jwt_key=supersecretkey" \
  -e "db_username=postgres" \
  -e "db_password=postgres" \
  -e "db_name=conduit_development" \
  -e "db_hostname=SEU_DB_HOST"
```

**Variáveis necessárias:**
- `docker_username` - Usuário Docker Hub
- `docker_password` - Senha Docker Hub
- `jwt_key` - Chave JWT
- `db_username` - Usuário do banco
- `db_password` - Senha do banco
- `db_name` - Nome do banco
- `db_hostname` - Host do banco

### Deploy Kubernetes (Frontend)

Aplica manifestos Kubernetes para o frontend.

**O que faz:**
1. Verifica kubectl
2. Aplica namespace
3. Aplica quotas e limites
4. Aplica deployment
5. Aplica service, ingress e HPA
6. Aplica StatefulSet do banco
7. Aguarda pods ficarem prontos

**Executar:**

```bash
cd infra/ansible
ansible-playbook playbooks/deploy-k8s.yml
```

> **Nota**: Requer kubectl configurado com acesso ao cluster AKS

## Integração com CI/CD

Os playbooks são chamados automaticamente pela pipeline GitHub Actions:

```yaml
- name: Deploy Docker
  run: |
    ansible-playbook playbooks/deploy-docker.yml \
      -e "docker_username=${{ secrets.DOCKER_USERNAME }}" \
      # ... outras variáveis
```

## Troubleshooting

### Erro de SSH

```bash
# Verificar conectividade
ansible docker_hosts -m ping

# Testar SSH manualmente
ssh azureuser@<IP_DA_VM>
```

### Erro de permissão

```bash
# Executar com sudo
ansible-playbook playbooks/deploy-docker.yml --become
```

### Docker não instalado

O playbook `deploy-docker.yml` instala o Docker automaticamente.

### Kubectl não encontrado

Instale kubectl:

```bash
# Azure CLI
az aks install-cli

# Obter credenciais
az aks get-credentials --resource-group rg-conduit-devops --name aks-conduit
```

## Secrets Necessárias (GitHub Actions)

Configure no GitHub: **Settings → Secrets and variables → Actions**

- `SSH_PRIVATE_KEY` - Chave SSH privada
- `DOCKER_VM_IP` - IP da VM Docker
- `DOCKER_USERNAME` - Usuário Docker Hub
- `DOCKER_PASSWORD` - Senha Docker Hub
- `JWT_KEY` - Chave JWT
- `DB_USERNAME` - Usuário do banco
- `DB_PASSWORD` - Senha do banco
- `DB_NAME` - Nome do banco
- `DB_HOSTNAME` - Host do banco (FQDN do Azure PostgreSQL)
