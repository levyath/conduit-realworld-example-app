variable "project_id" {
  description = "ID do Projeto GCP"
  type        = string
}

variable "region" {
  description = "Região GCP"
  type        = string
}

variable "zone" {
  description = "Zona GCP"
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

variable "machine_type" {
  description = "Tipo de máquina"
  type        = string
}

variable "admin_username" {
  description = "Usuário admin"
  type        = string
}
