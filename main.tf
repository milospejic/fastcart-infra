terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
    project = var.gcp_project
    region  = var.gcp_region
}


module "networking" {
  source = "./modules/networking"
  gcp_region = var.gcp_region
  vpc_name = "${var.prefix}-vpc"
  subnet_name = "${var.prefix}-subnet"
  cidr_range         = "10.0.0.0/24"    
  pod_cidr_range     = "10.1.0.0/16"   
  service_cidr_range = "10.2.0.0/20"   
}


module "cloud_sql" {
  source = "./modules/cloud_sql"
  gcp_region = var.gcp_region
  prefix = var.prefix
  microservices = var.microservices
  database_version = var.database_version
  tier = var.tier
  vpc_id = module.networking.private_vpc_connection_id

  depends_on = [module.networking]
}

module "artifact_registry" {
  source     = "./modules/artifact_registry"
  prefix     = var.prefix
  gcp_region = var.gcp_region
}

module "gcs_frontend" {
  source     = "./modules/gcs_frontend"
  prefix     = var.prefix
  gcp_region = var.gcp_region
}

module "gke" {
  source             = "./modules/gke"
  prefix             = var.prefix
  gcp_project        = var.gcp_project
  gcp_region         = var.gcp_region
  
  vpc_name           = module.networking.network_name
  subnet_name        = module.networking.subnet_name
  pod_range_name     = module.networking.pod_range_name
  service_range_name = module.networking.service_range_name
  
  depends_on         = [module.networking]
}