variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "location" {
  description = "Localização Azure"
  type        = string
}

variable "postgres_admin_login" {
  description = "Usuário admin do PostgreSQL"
  type        = string
}

variable "postgres_admin_password" {
  description = "Senha admin do PostgreSQL"
  type        = string
  sensitive   = true
}
