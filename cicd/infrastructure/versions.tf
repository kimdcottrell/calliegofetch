# ----------------------------------------------------------------------------------------------------------------------
# SETUP TERRAFORM BASE CONFIG
# NOTE: Update the required_version to the last version successfully utilized.
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = "~> 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
  secret_key = var.secret_key
  access_key = var.access_key
}
