# Cloud SQL PostgreSQL Instance
resource "google_sql_database_instance" "postgres" {
  name             = "cloudsql-conduit-postgres"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = var.db_tier

    ip_configuration {
      ipv4_enabled = true
      
      # Permitir acesso da VM e GKE (melhor usar Private IP em produção)
      authorized_networks {
        name  = "allow-all-temp"
        value = "0.0.0.0/0"
      }
    }

    backup_configuration {
      enabled            = true
      start_time         = "02:00"
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 7
      }
    }

    database_flags {
      name  = "max_connections"
      value = "100"
    }
  }

  deletion_protection = false # Permitir deletar para testes
}

# Database
resource "google_sql_database" "conduit_db" {
  name     = "conduit"
  instance = google_sql_database_instance.postgres.name
}

# Database User
resource "google_sql_user" "postgres_user" {
  name     = "postgres"
  instance = google_sql_database_instance.postgres.name
  password = var.db_admin_password
}

# Database User adicional para aplicação
resource "google_sql_user" "app_user" {
  name     = "conduit_user"
  instance = google_sql_database_instance.postgres.name
  password = var.db_admin_password
}
