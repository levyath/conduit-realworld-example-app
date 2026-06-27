output "vm_name" {
  description = "Nome da VM"
  value       = google_compute_instance.app_vm.name
}

output "vm_public_ip" {
  description = "IP público da VM"
  value       = google_compute_instance.app_vm.network_interface[0].access_config[0].nat_ip
}

output "vm_private_ip" {
  description = "IP privado da VM"
  value       = google_compute_instance.app_vm.network_interface[0].network_ip
}

output "vm_zone" {
  description = "Zona da VM"
  value       = google_compute_instance.app_vm.zone
}
