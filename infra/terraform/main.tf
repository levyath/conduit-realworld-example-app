terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# VPC Network
resource "google_compute_network" "main" {
  name                    = "vpc-conduit"
  auto_create_subnetworks = false
}

# Subnet para VMs
resource "google_compute_subnetwork" "vms" {
  name          = "subnet-vms"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.main.id
  region        = var.region
}

# Subnet para GKE
resource "google_compute_subnetwork" "gke" {
  name          = "subnet-gke"
  ip_cidr_range = "10.0.2.0/24"
  network       = google_compute_network.main.id
  region        = var.region

  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "10.2.0.0/16"
  }
}

# Firewall - Allow SSH
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-enabled"]
}

# Firewall - Allow HTTP/HTTPS
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-https"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "3000", "3001", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}

# Módulo Compute Engine (VM para Docker + CI)
module "compute" {
  source = "./modules/compute"

  project_id     = var.project_id
  region         = var.region
  zone           = var.zone
  network        = google_compute_network.main.name
  subnetwork     = google_compute_subnetwork.vms.name
  machine_type   = var.vm_machine_type
  admin_username = var.admin_username
}

# Módulo GKE (Google Kubernetes Engine)
module "kubernetes" {
  source = "./modules/kubernetes"

  project_id   = var.project_id
  region       = var.region
  network      = google_compute_network.main.name
  subnetwork   = google_compute_subnetwork.gke.name
  node_count   = var.gke_node_count
  machine_type = var.gke_machine_type
}

# Módulo Cloud SQL (PostgreSQL)
module "database" {
  source = "./modules/database"

  project_id        = var.project_id
  region            = var.region
  network           = google_compute_network.main.id
  db_admin_password = var.db_admin_password
  db_tier           = var.db_tier
}
