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
variable "postgres_host_name" {
  default = "care_db"
}

variable "postgres_user_name" {
  default = "care"
}

variable "postgres_db_name" {
  default = "care"
}

variable "postgres_password" {
  default = "YourPwdShouldBeLongAndSecure!"
}

variable "postgres_port" {
  default = 5432   // using 5432 is not recommended choose a higher level port between 54000 - 70000
}

variable "kms_key_id" {
  default = ""
  description = "Create a kms key using aws kms then copy the key id here. make sure to use the same key everywhere"
}