variable "project_id" {
  description = "ID do Projeto GCP"
  type        = string
}

variable "region" {
  description = "Região GCP"
  type        = string
}

variable "network" {
  description = "ID da rede VPC"
  type        = string
}

variable "db_admin_password" {
  description = "Senha do admin do PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_tier" {
  description = "Tier do Cloud SQL"
  type        = string
}
