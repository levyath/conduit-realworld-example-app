# VM para Docker + CI
resource "google_compute_instance" "app_vm" {
  name         = "vm-conduit-app"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["ssh-enabled", "web-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 50 # GB
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "${var.admin_username}:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = <<-EOF
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
    usermod -aG docker ${var.admin_username}
    
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
    chown -R ${var.admin_username}:${var.admin_username} /opt/conduit
    
    echo "VM configurada com sucesso!"
  EOF

  service_account {
    scopes = ["cloud-platform"]
  }

  labels = {
    environment = "production"
    project     = "conduit"
    role        = "docker-ci"
  }
}
