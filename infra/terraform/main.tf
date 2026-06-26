terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "production"
    project     = "conduit"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-conduit"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Subnet para VMs
resource "azurerm_subnet" "vms" {
  name                 = "subnet-vms"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Subnet para AKS
resource "azurerm_subnet" "aks" {
  name                 = "subnet-aks"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Módulo Compute (VM combinada)
module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = azurerm_subnet.vms.id
  vm_size_app         = var.vm_size_app
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

# Módulo Kubernetes (AKS)
module "kubernetes" {
  source = "./modules/kubernetes"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = azurerm_subnet.aks.id
  node_count          = var.aks_node_count
  node_vm_size        = var.aks_node_vm_size
}

# Módulo Database (PostgreSQL)
module "database" {
  source = "./modules/database"

  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  postgres_admin_login      = var.postgres_admin_login
  postgres_admin_password   = var.postgres_admin_password
}
