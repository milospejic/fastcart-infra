resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "frontend_bucket" {
  name          = "${var.prefix}-frontend-${random_id.bucket_suffix.hex}"
  location      = var.gcp_region
  force_destroy = true 

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "OPTIONS"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_secret_manager_secret" "frontend_url" {
  secret_id = "${var.prefix}-frontend-url"
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "frontend_url_data" {
  secret      = google_secret_manager_secret.frontend_url.id
  secret_data = "https://${google_storage_bucket.frontend_bucket.name}.storage.googleapis.com"
}

resource "google_storage_bucket_iam_member" "public_frontend" {
  bucket = google_storage_bucket.frontend_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}