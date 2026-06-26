resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "psql-conduit"
  location               = var.location
  resource_group_name    = var.resource_group_name
  administrator_login    = var.postgres_admin_login
  administrator_password = var.postgres_admin_password
  
  sku_name   = "B_Standard_B1ms"
  version    = "16"
  storage_mb = 32768

  backup_retention_days = 7
  geo_redundant_backup_enabled = false

  tags = {
    environment = "production"
    project     = "conduit"
  }
}

resource "azurerm_postgresql_flexible_server_database" "conduit_db" {
  name      = "conduit_development"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "allow-all"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
