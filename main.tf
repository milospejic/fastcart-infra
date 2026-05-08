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

