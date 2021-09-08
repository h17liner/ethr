module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "chaind"

  engine               = "postgres"
  engine_version       = "13.3"
  family               = "postgres13" # DB parameter group
  major_engine_version = "13"         # DB option group
  instance_class       = "db.t3.small"
  
  allocated_storage    = 5

  name     = "chaindb"
  username = "chaindb"
  password = "chaindbchaindb"
  port     = "5432"

  multi_az               = true
  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [module.db-sg.security_group_id]

  backup_retention_period = 3

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    }
  ]

  tags = merge(
    local.tags,
    {
        Service = "chaind"
        Role    = "db"
    },
  )

}