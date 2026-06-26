variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "location" {
  description = "Localização Azure"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet para o AKS"
  type        = string
}

variable "node_count" {
  description = "Número de nodes"
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "Tamanho das VMs dos nodes"
  type        = string
}
