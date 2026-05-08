resource "google_compute_network" "default" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = var.subnet_name
  ip_cidr_range = var.cidr_range
  region        = var.gcp_region
  network       = google_compute_network.default.self_link
}

