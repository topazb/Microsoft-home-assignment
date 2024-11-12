terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"  # Adjust based on your preferred version
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.0"  # Adjust based on your preferred version
    }
  }
}

provider "aws" {
  region = var.region  # Default region
}
