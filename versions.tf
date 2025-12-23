terraform {
  required_version = ">= 1.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = ">= 5.9.0"
    }
    local = {
      source  = "hashicorp/local",
      version = ">= 2.4.0"
    }
    external = {
      source  = "hashicorp/external",
      version = ">= 1.0.0"
    }
  }
}