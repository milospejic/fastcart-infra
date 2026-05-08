terraform {
  backend "gcs" {
    bucket = "fastcart-state"
    prefix = "terraform/state/dev"
  }
}