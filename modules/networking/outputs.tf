output "network_name" {
  value = google_compute_network.default.name
}

output "subnet_name" {
  value = google_compute_subnetwork.default.name
}

output "pod_range_name" {
  value = google_compute_subnetwork.default.secondary_ip_range[0].range_name
}

output "service_range_name" {
  value = google_compute_subnetwork.default.secondary_ip_range[1].range_name
}

output "private_vpc_connection_id" {
  value = google_service_networking_connection.private_vpc_connection.network
}