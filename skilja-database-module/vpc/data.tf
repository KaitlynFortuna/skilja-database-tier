data "aws_ssm_parameter" "vpc_database_subnets_cidr_blocks" {

  name                            = "/vpc/database_subnets_cidr_blocks"
  vpc_private_subnets_cidr_blocks = tolist(split(",", data.aws_ssm_parameter.vpc_database_subnets_cidr_blocks.value))
}

data "aws_ssm_parameter" "vpc_database_subnets" {
  name = "/vpc/database_subnets"
}
