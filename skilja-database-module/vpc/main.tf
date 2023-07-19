module "vpc" {
  #   source  = "terraform-aws-modules/vpc/aws"
  #   version = "5.0.0"

  name                             = "education"
  vpc_database_subnets_cidr_blocks = data.aws_ssm_parameter.vpc_database_subnets_cidr_blocks.value
  azs                              = data.aws_availability_zones.available.names
  vpc_database_subnets             = data.aws_ssm_parameter.database_subnets.value
  enable_dns_hostnames             = true
  enable_dns_support               = true
}
