output "docker_vm_public_ip" {
  description = "IP público da VM Docker"
  value       = azurerm_public_ip.docker_vm.ip_address
}

output "ci_vm_public_ip" {
  description = "IP público da VM CI"
  value       = azurerm_public_ip.ci_vm.ip_address
}

output "docker_vm_id" {
  description = "ID da VM Docker"
  value       = azurerm_linux_virtual_machine.docker_vm.id
}

output "ci_vm_id" {
  description = "ID da VM CI"
  value       = azurerm_linux_virtual_machine.ci_vm.id
}
