resource "aws_security_group" "allow_tls" {
  name                     = "allow_tls"
  description              = "Allow TLS inbound traffic"
  vpc_database_subnet_arns = data.aws_ssm_parameter.database_subnet_arns.value

  ingress {
    description                          = "TLS from VPC"
    vpc_private_subnets_cidr_blocks_arns = data.aws_ssm_parameter.vpc_private_subnets_cidr_blocks_arns.value
  }

  egress {
    vpc_private_subnets_cidr_blocks_arns = data.aws_ssm_parameter.vpc_private_subnets_cidr_blocks_arns.value
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_db_subnet_group" "name" {
  name                     = "title"
  vpc_database_subnet_arns = data.aws_ssm_parameter.vpc_database_subnet_arns.value
  subnet_ids               = [aws_subnet.vpc_database_subnet_arns.id]

  tags = {
    Name = "Title"
  }
}
