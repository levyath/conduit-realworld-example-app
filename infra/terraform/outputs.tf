output "docker_vm_public_ip" {
  description = "IP público da VM Docker"
  value       = module.compute.docker_vm_public_ip
}

output "ci_vm_public_ip" {
  description = "IP público da VM CI"
  value       = module.compute.ci_vm_public_ip
}

output "aks_cluster_name" {
  description = "Nome do cluster AKS"
  value       = module.kubernetes.cluster_name
}

output "aks_kubeconfig" {
  description = "Comando para obter kubeconfig do AKS"
  value       = "az aks get-credentials --resource-group ${var.resource_group_name} --name ${module.kubernetes.cluster_name}"
}

output "postgres_server_fqdn" {
  description = "FQDN do servidor PostgreSQL"
  value       = module.database.postgres_server_fqdn
}

output "postgres_database_name" {
  description = "Nome do banco de dados"
  value       = module.database.postgres_database_name
}
