data "aws_ssm_parameter" "db_subnet_group_name" {
  name = "/vpc/private_subnets"
}


