output "app_vm_public_ip" {
  description = "IP público da VM de Aplicação"
  value       = azurerm_public_ip.app_vm.ip_address
}

output "app_vm_id" {
  description = "ID da VM de Aplicação"
  value       = azurerm_linux_virtual_machine.app_vm.id
}
