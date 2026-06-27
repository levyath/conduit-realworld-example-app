variable "project_id" {
  description = "ID do Projeto GCP"
  type        = string
}

variable "region" {
  description = "Região GCP"
  type        = string
}

variable "network" {
  description = "Nome da rede VPC"
  type        = string
}

variable "subnetwork" {
  description = "Nome da subnet"
  type        = string
}

variable "node_count" {
  description = "Número de nodes"
  type        = number
}

variable "machine_type" {
  description = "Tipo de máquina para os nodes"
  type        = string
}
