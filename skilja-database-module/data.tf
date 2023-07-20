data "aws_ssm_parameter" "vpc_private_subnet_arns" {
  name = "/vpc/private_subnet_arns"
}

data "aws_ssm_parameter" "vpc_private_subnets_cidr_blocks_arns" {

  name = "/vpc/database_subnets_cidr_blocks"
}

data "aws_ssm_parameter" "vpc_database_subnet_arns" {
  name = "/vpc/database_subnet_arns"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/vpc/vpc_id"
}

data "aws_ssm_parameter" "database_subnets" {
  name = "/vpc/database_subnets"
}


