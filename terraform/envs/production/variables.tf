locals {
  region      = "eu-west-2"
  environment = "production"

  project = "tktest"
  
  vpc-name = "${local.project}-vpc-${local.environment}"

  tags = {
      Terraform = "true"
      Environment = local.environment
      Region = local.region
      Goal = local.project
  }
}


terraform {
  backend "s3" {
    bucket = "tktest-state"
    key    = "tktest-env"
    region = "eu-west-2"
  }
}

#  VPN octet
variable "octet" {
  type = number
  default = 101
}


# chaind rds
variable "chaindb_name" {
  type = string
  default = "chaindb"
}

variable "chaindb_username" {
  type = string
  default = "chaindb"
}

variable "chaindb_password" {
  type = string
  default = "chaindb"
  sensitive   = true
}
