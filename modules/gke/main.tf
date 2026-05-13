
resource "google_service_account" "default" {
  account_id   = "${var.prefix}-gke-nodes-sa"
  display_name = "Service Account for GKE Nodes"
  project      = var.gcp_project
}

resource "google_project_iam_member" "gke_nodes_log_writer" {
  project = var.gcp_project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "gke_nodes_metric_writer" {
  project = var.gcp_project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "gke_nodes_artifact_reader" {
  project = var.gcp_project
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "gke_nodes_secret_accessor" {
  project = var.gcp_project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.default.email}"
}


resource "google_container_cluster" "default" {
  name     = "${var.prefix}-cluster"
  location = "${var.gcp_region}-a" 
  
  network    = var.vpc_name
  subnetwork = var.subnet_name

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_range_name
    services_secondary_range_name = var.service_range_name
  }

  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${var.gcp_project}.svc.id.goog"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false 
    }
  }
}


resource "google_container_node_pool" "default" {
  name       = "${var.prefix}-spot-pool"
  location   = "${var.gcp_region}-a"
  cluster    = google_container_cluster.default.name
  node_count = 1 

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-medium" 
    spot         = true        
    
    service_account = google_service_account.default.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      env = "dev"
    }
    
    tags = ["gke-node"]
  }
}