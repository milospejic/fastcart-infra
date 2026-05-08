variable "prefix" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "microservices" {
  type        = set(string)
  description = "List of microservices to create databases and users for"
}

variable "database_version" {
  description = "Database version"
  type = string
  default = "POSTGRES_15"
}

variable "tier" {
  description = "The machine type to use. See https://cloud.google.com/sql/docs/postgres/instance-settings#machine-type for more details."
  type        = string
  default     = "db-f1-micro"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC network to attach the private database to"
}
