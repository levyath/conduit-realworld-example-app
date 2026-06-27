#!/bin/bash
set -e

# Log de execução
exec 1>/var/log/startup-script.log 2>&1

echo "Iniciando configuração da VM..."

# Atualizar sistema
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sh /tmp/get-docker.sh

# Adicionar usuário ao grupo docker
usermod -aG docker gcpuser

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Instalar Git
apt-get install -y git

# Iniciar Docker
systemctl enable docker
systemctl start docker

# Criar diretório para aplicação
mkdir -p /opt/conduit
chown -R gcpuser:gcpuser /opt/conduit

echo "VM configurada com sucesso!"
