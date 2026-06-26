output "postgres_server_fqdn" {
  description = "FQDN do servidor PostgreSQL"
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "postgres_database_name" {
  description = "Nome do banco de dados"
  value       = azurerm_postgresql_flexible_server_database.conduit_db.name
}

output "postgres_server_id" {
  description = "ID do servidor PostgreSQL"
  value       = azurerm_postgresql_flexible_server.postgres.id
}
