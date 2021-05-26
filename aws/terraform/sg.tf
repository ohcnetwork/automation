resource "aws_security_group" "allow_all_inside_vpc" {
  vpc_id = module.vpc.vpc_id
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = [var.default_cidr]
    description = "Allow all traffic inside the vpc"
  }
  name        = "allow_all_inside_vpc"
  description = "Allow all traffic inside the vpc"
  tags = {
    Owner       = var.namespace
    Environment = var.environment
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "20.0.0.0/16"
    ]
  }

  ingress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = [var.default_cidr]
    description = "Allow all traffic inside the vpc"
  }
}