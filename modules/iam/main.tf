resource "random_id" "wif_suffix" {
  byte_length = 4
}

resource "google_service_account" "default" {
  account_id   = "gh-actions-${random_id.wif_suffix.hex}"
  display_name = "GitHub Actions Service Account"
  project      = var.gcp_project
}

resource "google_project_iam_member" "github_ar_writer" {
  project = var.gcp_project
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_iam_workload_identity_pool" "default" {
  workload_identity_pool_id = "gh-pool-${random_id.wif_suffix.hex}"
  display_name              = "GitHub Actions Pool"
  project                   = var.gcp_project
}

resource "google_iam_workload_identity_pool_provider" "default" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.default.workload_identity_pool_id
  workload_identity_pool_provider_id = "gh-prov-${random_id.wif_suffix.hex}"
  project                            = var.gcp_project
  
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  attribute_condition = "assertion.repository == '${var.github_repo}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github_sa_impersonation" {
  service_account_id = google_service_account.default.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.default.name}/attribute.repository/${var.github_repo}"
}