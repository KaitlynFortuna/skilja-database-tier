resource "aws_security_group" "rds" {
  name                     = "name_rds"
  vpc_database_subnet_arns = data.aws_ssm_parameter.database_subnet_arns.value

  ingress {
    description                          = "TLS from VPC"
    vpc_private_subnets_cidr_blocks_arns = data.aws_ssm_parameter.vpc_private_subnets_cidr_blocks_arns.value
  }

  egress {
    vpc_private_subnets_cidr_blocks_arns = data.aws_ssm_parameter.vpc_private_subnets_cidr_blocks_arns.value
  }

  tags = {
    Name = "name_rds"
  }
}

resource "aws_db_parameter_group" "name" {
  name   = "name"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}
