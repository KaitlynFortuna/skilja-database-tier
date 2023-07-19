resource "aws_security_group" "rds" {
  name                     = "education_rds"
  vpc_database_subnet_arns = data.aws_ssm_parameter.database_subnet_arns.value

  ingress {
    description                      = "TLS from VPC"
    vpc_database_subnets_cidr_blocks = data.aws_ssm_parameter.vpc_database_subnets_cidr_blocks.value
  }

  egress {
    vpc_database_subnets_cidr_blocks = data.aws_ssm_parameter.vpc_database_subnets_cidr_blocks.value
  }

  tags = {
    Name = "education_rds"
  }
}

resource "aws_db_parameter_group" "education" {
  name   = "education"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}
