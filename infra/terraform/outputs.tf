output "vm_public_ip" {
  description = "IP público da VM (Docker + CI)"
  value       = module.compute.vm_public_ip
}

output "vm_name" {
  description = "Nome da VM"
  value       = module.compute.vm_name
}

output "gke_cluster_name" {
  description = "Nome do cluster GKE"
  value       = module.kubernetes.cluster_name
}

output "gke_kubeconfig_command" {
  description = "Comando para obter kubeconfig do GKE"
  value       = "gcloud container clusters get-credentials ${module.kubernetes.cluster_name} --region ${var.region} --project ${var.project_id}"
}

output "db_public_ip" {
  description = "IP público do Cloud SQL"
  value       = module.database.public_ip
}

output "db_connection_name" {
  description = "Connection name do Cloud SQL"
  value       = module.database.connection_name
}

output "database_name" {
  description = "Nome do banco de dados"
  value       = module.database.database_name
}
