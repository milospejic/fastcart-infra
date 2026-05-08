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
