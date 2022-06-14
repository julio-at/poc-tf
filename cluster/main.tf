terraform {
  required_version = ">= 1.1.9"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.3.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.18.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_key
}

resource "random_id" "id" {
  byte_length = 2
}
