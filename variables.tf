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

variable "microservices" {
  description = "List of microservices that need a database"
  type        = set(string)
  default     = ["users", "products", "orders", "cart", "payments"]
}

variable "database_version" {
  description = "The version of the database to use. For example, POSTGRES_15."
  type        = string
  default     = "POSTGRES_15"
}

variable "tier" {
  description = "The machine type to use for the Cloud SQL instance. For example, db-f1-micro."
  type        = string
  default     = "db-f1-micro"
}
