variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "location" {
  description = "Localização Azure"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet"
  type        = string
}

variable "vm_size_app" {
  description = "Tamanho da VM de Aplicação (Docker + CI)"
  type        = string
}

variable "admin_username" {
  description = "Usuário admin"
  type        = string
}

variable "admin_password" {
  description = "Senha admin"
  type        = string
  sensitive   = true
}
