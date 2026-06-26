output "cluster_name" {
  description = "Nome do cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "cluster_id" {
  description = "ID do cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "kube_config" {
  description = "Configuração do Kubernetes"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}
