
resource "aws_eip" "nat" {
  count = 3

  vpc = true
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                               = "vpc-${var.namespace}"
  cidr                               = var.default_cidr
  azs                                = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets                    = ["20.0.0.0/19", "20.0.32.0/19", "20.0.64.0/19"]
  public_subnets                     = ["20.0.96.0/19", "20.0.128.0/19", "20.0.160.0/19"]
  database_subnets                   = ["20.0.192.0/19", "20.0.224.0/20", "20.0.240.0/20"]
  create_database_subnet_group       = true
  enable_nat_gateway                 = true
  single_nat_gateway                 = false
  one_nat_gateway_per_az             = true
  reuse_nat_ips                      = true
  external_nat_ip_ids                = aws_eip.nat.*.id
  enable_dns_support                 = true
  manage_default_route_table         = true
  create_database_subnet_route_table = true
  default_route_table_tags           = { DefaultRouteTable = true }
  enable_dns_hostnames               = true
  enable_ipv6                        = true
  assign_ipv6_address_on_creation    = true

  private_subnet_assign_ipv6_address_on_creation  = false
  database_subnet_assign_ipv6_address_on_creation = false
  public_subnet_ipv6_prefixes                     = [0, 1, 2]
  private_subnet_ipv6_prefixes                    = [3, 4, 5]
  database_subnet_ipv6_prefixes                   = [6, 7, 8]

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  tags = {
    Environment = "production"
    Terraform   = "true"
    Owner       = var.namespace
  }

}