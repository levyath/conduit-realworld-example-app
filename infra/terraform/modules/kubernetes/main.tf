resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-conduit"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "conduit"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }

  tags = {
    environment = "production"
    project     = "conduit"
  }
}
