
data "aws_iam_user" "tktest-production-admin" {
  user_name = "tktest"
}

data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ssm
module "iam-role-tktest-production-admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_services = [
      "ec2.amazonaws.com",
      "ssm.amazonaws.com"
  ]

  create_role = true
  create_instance_profile = true

  role_name         = "tktest-production-profile"
  role_requires_mfa = false

  custom_role_policy_arns = [
    data.aws_iam_policy.ssm.arn
  ]

  tags = local.tags
}


