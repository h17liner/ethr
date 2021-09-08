provider "aws" {
    region = local.region
}

data "aws_availability_zones" "available" {
}

## Create VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name                 = local.vpc-name
  cidr                 = "10.${var.octet}.0.0/16"

  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.${var.octet}.1.0/24", "10.${var.octet}.2.0/24", "10.${var.octet}.3.0/24"]
  public_subnets       = ["10.${var.octet}.11.0/24", "10.${var.octet}.12.0/24", "10.${var.octet}.13.0/24"]
  database_subnets     = ["10.${var.octet}.21.0/24", "10.${var.octet}.22.0/24", "10.${var.octet}.23.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = local.tags
}


# main security group. 
# allow: ssh, ssm.
module "main-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "main"
  description = "Main security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "80"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "443"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}


# db security group
module "db-sg" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "db"
  description = "Database security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "5432"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}
