output "instance_name" {
  description = "Nome da instância Cloud SQL"
  value       = google_sql_database_instance.postgres.name
}

output "connection_name" {
  description = "Connection name (project:region:instance)"
  value       = google_sql_database_instance.postgres.connection_name
}

output "public_ip" {
  description = "IP público do Cloud SQL"
  value       = google_sql_database_instance.postgres.public_ip_address
}

output "private_ip" {
  description = "IP privado do Cloud SQL"
  value       = google_sql_database_instance.postgres.private_ip_address
}

output "database_name" {
  description = "Nome do banco de dados"
  value       = google_sql_database.conduit_db.name
}
