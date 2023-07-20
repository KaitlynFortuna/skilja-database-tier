provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}

# resource "aws_db_instance" "dbName" {
#   identifier             = "${var.unique_id}-rds"
#   instance_class         = "db.t3.medium"
#   allocated_storage      = 5
#   engine                 = "aurora-postgresql"
#   engine_version         = "14.6"
#   username               = "Skilja"
#   password               = data.aws_secretsmanager_random_password.rds_password.random_password
#   db_subnet_group_name   = aws_db_subnet_group.main.name
#   vpc_security_group_ids = [aws_security_group.rds.id]
#   parameter_group_name   = "default.aurora-postgresql14"
#   publicly_accessible    = false
#   skip_final_snapshot    = true
# }

resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = "${var.unique_id}-rds"
  engine                  = "aurora-postgresql"
  engine_version          = "14.6"
  availability_zones      = ["us-east-2a", "us-east-2b"]
  database_name           = "Skilja"
  master_username         = "Skilja"
  master_password         = data.aws_secretsmanager_random_password.rds_password.random_password
  backup_retention_period = 0
  skip_final_snapshot     = true

  lifecycle {
    ignore_changes = [master_password, ]
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.postgresql.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.postgresql.engine
  engine_version     = aws_rds_cluster.postgresql.engine_version
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = split(",", data.aws_ssm_parameter.database_subnets.value)

  tags = {
    Name = "My DB subnet group"
  }
}

// RDS Database outputs

# output "rds_hostname" {
#   description = "RDS instance hostname"
#   value       = aws_db_instance.dbName.address
#   sensitive   = true
# }

# output "rds_port" {
#   description = "RDS instance port"
#   value       = aws_db_instance.dbName.port
#   sensitive   = true
# }

# output "rds_username" {
#   description = "RDS instance root username"
#   value       = aws_db_instance.dbName.username
#   sensitive   = true
# }

# resource "aws_launch_template" "rds" {
#   name_prefix   = "rds-sg-as"
#   image_id      = "ami-1a2b3c"
#   instance_type = "t2.micro"
# }

// Database creds

variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

# Generates a unique name for a domain service account to run OnBase services and sets up the password in AWS Secrets Manager

data "aws_secretsmanager_random_password" "rds_password" {
  password_length            = 32
  require_each_included_type = true
}

# locals {
#   rds_password_username = random_id.rds_password_username.hex
# }

resource "aws_secretsmanager_secret" "rds_password_account_password" {
  description             = "user"
  name                    = "${var.unique_id}-rds_password_account"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_password_account_password" {
  secret_id     = aws_secretsmanager_secret.rds_password_account_password.id
  secret_string = data.aws_secretsmanager_random_password.rds_password.random_password
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
