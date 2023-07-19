resource "aws_security_group" "allow_tls" {
  name                     = "allow_tls"
  description              = "Allow TLS inbound traffic"
  vpc_database_subnet_arns = data.aws_ssm_parameter.database_subnet_arns.value

  ingress {
    description                      = "TLS from VPC"
    vpc_database_subnets_cidr_blocks = data.aws_ssm_parameter.vpc_database_subnets_cidr_blocks.value
  }

  egress {
    vpc_database_subnets_cidr_blocks = data.aws_ssm_parameter.vpc_database_subnets_cidr_blocks.value
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_db_subnet_group" "education" {
  name                     = "title"
  vpc_database_subnet_arns = data.aws_ssm_parameter.vpc_database_subnet_arns.value

  tags = {
    Name = "Title"
  }
}
