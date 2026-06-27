variable "project_id" {
  description = "ID do Projeto GCP"
  type        = string
}

variable "region" {
  description = "Região GCP"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona GCP"
  type        = string
  default     = "us-central1-a"
}

variable "vm_machine_type" {
  description = "Tipo de máquina para VM (Docker + CI)"
  type        = string
  default     = "e2-standard-2" # 2 vCPUs, 8 GB RAM
}

variable "admin_username" {
  description = "Usuário admin da VM"
  type        = string
  default     = "gcpuser"
}

variable "gke_node_count" {
  description = "Número de nodes no GKE"
  type        = number
  default     = 1
}

variable "gke_machine_type" {
  description = "Tipo de máquina para nodes GKE"
  type        = string
  default     = "e2-standard-2" # 2 vCPUs, 8 GB RAM
}

variable "db_admin_password" {
  description = "Senha do admin do PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_tier" {
  description = "Tier do Cloud SQL"
  type        = string
  default     = "db-f1-micro" # Instância pequena
}
