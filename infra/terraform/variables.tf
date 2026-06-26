variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "rg-conduit-devops"
}

variable "location" {
  description = "Localização dos recursos Azure"
  type        = string
  default     = "North Central US"
}

variable "vm_size_docker" {
  description = "Tamanho da VM para Docker"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "vm_size_ci" {
  description = "Tamanho da VM para CI"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Usuário admin das VMs"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Senha admin das VMs"
  type        = string
  sensitive   = true
}

variable "postgres_admin_login" {
  description = "Usuário admin do PostgreSQL"
  type        = string
  default     = "psqladmin"
}

variable "postgres_admin_password" {
  description = "Senha admin do PostgreSQL"
  type        = string
  sensitive   = true
}

variable "aks_node_count" {
  description = "Número de nodes no AKS"
  type        = number
  default     = 2
}

variable "aks_node_vm_size" {
  description = "Tamanho das VMs do AKS"
  type        = string
  default     = "Standard_D2as_v4"
}
