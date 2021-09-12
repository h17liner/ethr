
locals {
  teku-nodes = 1
  chaind-nodes = 1
}

## Get ubuntu
/* aws ec2 describe-images --region eu-west-2 --filter="Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-*21*amd64*" */
data "aws_ami" "ubuntu" {
  most_recent      = true
  owners           = ["amazon", "099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*20*amd64*"]
  }
}


## teku instances
module "teku-instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  count = local.teku-nodes

  name = "tktest-node-${count.index}"

  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = "t2.medium"
  monitoring             = true
  vpc_security_group_ids = [module.main-sg.security_group_id]
  subnet_id              = tolist(module.vpc.private_subnets)[0]
  iam_instance_profile   = module.iam-role-tktest-production-admin.iam_instance_profile_name
  user_data              = file("${path.module}/cloud-config/cloud-config.yaml")

  tags = merge(
    local.tags,
    {
        Service = "teku"
        Role    = "node"
    },
  )
}


## chaind instanses
module "chaind-instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  count = local.chaind-nodes

  name = "chaind-node-${count.index}"
  
  instance_type          = "t2.micro"

  monitoring             = true
  ami                    = data.aws_ami.ubuntu.image_id
  vpc_security_group_ids = [module.main-sg.security_group_id, module.db-sg.security_group_id]
  subnet_id              = tolist(module.vpc.private_subnets)[0]
  iam_instance_profile   = module.iam-role-tktest-production-admin.iam_instance_profile_name
  user_data              = file("${path.module}/cloud-config/cloud-config.yaml")
  
  tags = merge(
    local.tags,
    {
        Service = "chaind"
        Role    = "node"
    },
  )
}

