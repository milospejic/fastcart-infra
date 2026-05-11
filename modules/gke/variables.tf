variable "prefix" {
  description = "Prefix for the cluster name"
  type        = string
}

variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP Region"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "subnet_name" {
  description = "The name of the Subnet"
  type        = string
}

variable "pod_range_name" {
  description = "The secondary range name for pods"
  type        = string
}

variable "service_range_name" {
  description = "The secondary range name for services"
  type        = string
}