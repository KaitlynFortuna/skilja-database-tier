provider "aws" {
  region = "us-east-2"
}

module "dc_instance" {

  data "aws_availability_zones" "available" {}

  resource "aws_db_instance" "education" {
    identifier             = "education"
    instance_class         = "db.t3.micro"
    allocated_storage      = 5
    engine                 = "postgres"
    engine_version         = "14.1"
    username               = "edu"
    password               = var.db_password
    db_subnet_group_name   = aws_db_subnet_group.education.name
    vpc_security_group_ids = [aws_security_group.rds.id]
    parameter_group_name   = aws_db_parameter_group.education.name
    publicly_accessible    = true
    skip_final_snapshot    = true
  }

  // RDS Database outputs

  output "rds_hostname" {
    description = "RDS instance hostname"
    value       = aws_db_instance.education.address
    sensitive   = true
  }

  output "rds_port" {
    description = "RDS instance port"
    value       = aws_db_instance.education.port
    sensitive   = true
  }

  output "rds_username" {
    description = "RDS instance root username"
    value       = aws_db_instance.education.username
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

  variable "db_password" {
    description = "RDS root user password"
    sensitive   = true
  }

  // ec2

  resource "aws_launch_template" "ec2-g" {
    name_prefix   = "ec2-sg-as"
    image_id      = "ami-1a2b3c"
    instance_type = "t2.micro"
  }

}
