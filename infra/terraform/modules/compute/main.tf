# Network Security Group
resource "azurerm_network_security_group" "vms" {
  name                = "nsg-vms"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AppPort"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# VM Docker - Public IP
resource "azurerm_public_ip" "docker_vm" {
  name                = "pip-docker-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# VM Docker - Network Interface
resource "azurerm_network_interface" "docker_vm" {
  name                = "nic-docker-vm"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.docker_vm.id
  }
}

# Associa NSG ao NIC da VM Docker
resource "azurerm_network_interface_security_group_association" "docker_vm" {
  network_interface_id      = azurerm_network_interface.docker_vm.id
  network_security_group_id = azurerm_network_security_group.vms.id
}

# VM Docker
resource "azurerm_linux_virtual_machine" "docker_vm" {
  name                = "vm-docker"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size_docker
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.docker_vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    environment = "production"
    role        = "docker-host"
  }
}

# VM CI - Public IP
resource "azurerm_public_ip" "ci_vm" {
  name                = "pip-ci-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# VM CI - Network Interface
resource "azurerm_network_interface" "ci_vm" {
  name                = "nic-ci-vm"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ci_vm.id
  }
}

# Associa NSG ao NIC da VM CI
resource "azurerm_network_interface_security_group_association" "ci_vm" {
  network_interface_id      = azurerm_network_interface.ci_vm.id
  network_security_group_id = azurerm_network_security_group.vms.id
}

# VM CI
resource "azurerm_linux_virtual_machine" "ci_vm" {
  name                = "vm-ci"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size_ci
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.ci_vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    environment = "production"
    role        = "ci-server"
  }
}
