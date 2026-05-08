resource "google_artifact_registry_repository" "default" {
  location      = var.gcp_region
  repository_id = "${var.prefix}-docker-repo"
  description   = "Docker repository for FastAPI microservices"
  format        = "DOCKER"
}