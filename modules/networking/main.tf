resource "google_compute_network" "default" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = var.subnet_name
  ip_cidr_range = var.cidr_range
  region        = var.gcp_region
  network       = google_compute_network.default.self_link

  secondary_ip_range = [
    {
      range_name    = "${var.subnet_name}-pods"
      ip_cidr_range = var.pod_cidr_range
    },
    {
      range_name    = "${var.subnet_name}-services"
      ip_cidr_range = var.service_cidr_range
    }
  ]
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "${var.vpc_name}-private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.default.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

