resource "random_id" "db_name_suffix" {
  byte_length = 4 
}

resource "google_sql_database_instance" "default" {
  name             = "${var.prefix}-pg-${random_id.db_name_suffix.hex}"
  database_version = var.database_version
  region           = var.gcp_region
  deletion_protection = false

  settings {
    tier = var.tier
    availability_type = "ZONAL" 
    disk_type         = "PD_HDD"
    disk_size         = 10
    
    ip_configuration {
      ipv4_enabled    = false       
      private_network = var.vpc_id 
      require_ssl     = false
    }
  }
  
}

resource "google_sql_database" "default" {
  for_each = var.microservices
  name     = "${each.key}_db"
  instance = google_sql_database_instance.default.name
}

resource "random_password" "db_passwords" {
  for_each = var.microservices
  length   = 16
  special  = false
}

resource "google_sql_user" "users" {
  for_each = var.microservices
  name     = "${each.key}_user"
  instance = google_sql_database_instance.default.name
  password = random_password.db_passwords[each.key].result
}

resource "google_secret_manager_secret" "db_passwords" {
  for_each  = var.microservices
  secret_id = "${var.prefix}-${each.key}-db-password"
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_passwords_data" {
  for_each    = var.microservices
  secret      = google_secret_manager_secret.db_passwords[each.key].id
  secret_data = random_password.db_passwords[each.key].result
}

resource "google_secret_manager_secret" "db_host" {
  secret_id = "${var.prefix}-db-host"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_host_data" {
  secret      = google_secret_manager_secret.db_host.id
  secret_data = google_sql_database_instance.default.private_ip_address
}