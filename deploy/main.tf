terraform {
  required_version = ">= 1.1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.18.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_key
}

data "aws_eks_cluster_auth" "cluster" {
  name = "eks-${var.environment}-${var.target}"
}

data "aws_eks_cluster" "cluster" {
  name = "eks-${var.environment}-${var.target}"
}

provider "helm" {
  alias = "provider"

  kubernetes {
    host  = data.aws_eks_cluster.cluster.endpoint
    token = data.aws_eks_cluster_auth.cluster.token

    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.cluster.certificate_authority[0].data
    )
  }
}
