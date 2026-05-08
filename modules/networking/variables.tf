variable "gcp_region" {
  description = "The region for the project"
  type = string
  default = "europe-west3"
}

variable "vpc_name" {
  description = "The name of the VPC network"
  type = string
  default = "default"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type = string
  default = "default"
}

variable "cidr_range" {
  description = "The CIDR range for the subnet"
  type = string
  default = "10.0.0.0/16"
}

variable "pod_cidr_range" {
  description = "The CIDR range for the pods"
  type = string
  default = "10.1.0.0/16"
}

variable "service_cidr_range" {
  description = "The CIDR range for the services"
  type = string
  default = " 10.2.0.0/20"
}
  
