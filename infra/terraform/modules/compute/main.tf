# VM para Docker + CI
resource "google_compute_instance" "app_vm" {
  name         = "vm-conduit-app"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["ssh-enabled", "web-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 50 # GB
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "${var.admin_username}:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")

  service_account {
    scopes = ["cloud-platform"]
  }

  labels = {
    environment = "production"
    project     = "conduit"
    role        = "docker-ci"
  }
}
