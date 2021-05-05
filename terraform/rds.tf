module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier           = var.postgres_db_name
  engine               = "postgres"
  engine_version       = "12.6"
  family               = "postgres12" # DB parameter group
  major_engine_version = "12"         # DB option group
  instance_class       = "db.t3.large"

  allocated_storage     = 20
  storage_type          = "gp2"
  max_allocated_storage = 100
  name                  = var.postgres_host_name
  username              = var.postgres_user_name
  password              = var.postgres_password
  port                  = var.postgres_port

  multi_az                  = true
  subnet_ids                = module.vpc.database_subnets
  create_db_subnet_group    = false
  db_subnet_group_name      = module.vpc.database_subnet_group_name
  vpc_security_group_ids    = [aws_security_group.postgres]
  create_db_parameter_group = false
  create_db_option_group    = false

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  backup_retention_period = 14
  skip_final_snapshot     = false
  deletion_protection     = true

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  kms_key_id                            = var.kms_key_id

  storage_encrypted = true

  publicly_accessible = false

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = {
    Environment = var.environment
    Terraform   = "true"
    Owner       = var.namespace
    Environment = var.environment
  }

  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
}