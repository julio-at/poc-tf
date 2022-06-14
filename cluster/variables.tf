variable "target" {
  default = "demo-deploy"
}

variable "environment" {
  type = string
}

# Route53
variable "aws_route53_record_name" {
  type        = string
  description = "Record name to add to aws_route_53. Must be a valid subdomain - www,app,etc"
  default     = "www"
}

variable "aws_route53_zone_name" {
  type        = string
  description = "Name of the zone to add records. Do not forget the trailing '.' - 'test.com.'"
  default     = "test.com."
}

# AWS
variable "aws_region" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

# VPC
variable "vpc_cidr" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

# EKS
variable "eks_worker_instance_types" {
  type = list(string)
  default = [
    "t2.micro",
    "t2.small"
  ]
}
