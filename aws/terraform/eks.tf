resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.eks_cluster_name
  cluster_version = "1.19"
  subnets         = module.vpc.private_subnets
  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]
  tags = {
    Environment = "production"
    Terraform   = "true"
    Owner       = var.namespace
  }
  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                 = "${var.namespace}-wg"
      instance_type        = "t3a.xlarge"
      asg_desired_capacity = 2
      asg_max_size         = 20
      workers_role_name = "master"
      additional_security_group_ids = [
        aws_security_group.all_worker_mgmt.id
      ]
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
