variable "gcp_region" {
    description = "The region for the project"
    type = string
    default = "europe-west3"
  }
  
variable "gcp_project" {
    description = "The GCP project ID"
    type = string
    default = "sara-sandbox-interns"
}

variable "prefix" {
    description = "The prefix for all resources"
    type = string
    default = "fastcart"
}

