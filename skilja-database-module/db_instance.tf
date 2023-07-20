provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}

resource "aws_db_instance" "dbName" {
  identifier        = "dbName"
  instance_class    = "db.t3.micro"
  allocated_storage = 5
  engine            = "postgres"
  engine_version    = "14.1"
  username          = "user"
  //Fix Bellow
  password               = aws_secretsmanager_secret_version.rds_password_version.secret_string
  db_subnet_group_name   = aws_db_subnet_group.dbName.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.dbName.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

// RDS Database outputs

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.dbName.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.dbName.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.dbName.username
  sensitive   = true
}

resource "aws_launch_template" "rds" {
  name_prefix   = "rds-sg-as"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

// Database creds

variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

# Generates a unique name for a domain service account to run OnBase services and sets up the password in AWS Secrets Manager

data "aws_secretsmanager_random_password" "rds_password" {
  password_length            = 32
  require_each_included_type = true
  name                       = "rds_password"
}

locals {
  rds_password_username = random_id.rds_password_username.hex
}

resource "aws_secretsmanager_secret" "rds_password_account_password" {
  description             = local.rds_password_account_username
  name                    = "${var.name}-rds_password_account_pw"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_password_account_password" {
  secret_id     = aws_secretsmanager_secret.rds_password_account_password.id
  secret_string = data.aws_secretsmanager_random_password.rds_password_account.random_password
  lifecycle {
    ignore_changes = [secret_string, ]
  }
}

resource "random_id" "rds_password_account_username" {
  # Generate a new random domain service account username
  # Max length of 20 and cannot contain "/ \ [ ] : ; | = , + * ? < >
  # https://learn.microsoft.com/en-us/windows/win32/adschema/a-samaccountname
  # Using a byte length of 7 and a prefix of 'obsvc-', the hex value of this resource will be 20 in length
  byte_length = 7
  prefix      = "obsvc-"
}

#   // ec2

#   resource "aws_launch_template" "ec2-g" {
#     name_prefix   = "ec2-sg-as"
#     image_id      = "ami-1a2b3c"
#     instance_type = "t2.micro"
#   }

