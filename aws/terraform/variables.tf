variable "namespace" {
  default = "care"
}
variable "region" {
  default = "ap-south-1"
}

variable "environment" {
  default = "production"
}

variable "default_cidr" {
  default = "20.0.0.0/16"
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "eks_cluster_name" {
  default = "care"
}