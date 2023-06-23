
// Initialize the database

# module "database" {
#   source = "git@github.com:HylandSoftware/terraform-aws-onbase-database.git"

#   default_configuration_script        = "OnBaseDefaultConfiguration"
#   directory_admin_secret_key          = data.aws_secretsmanager_secret.ad_adsecret.arn
#   directory_id                        = data.aws_ssm_parameter.active_directory_id.value
#   fsx_machine_name                    = data.aws_ssm_parameter.fsx_dns_name.value
#   fsx_powershell_endpoint             = data.aws_ssm_parameter.fsx_admin_endpoint.value
#   fsx_share_name                      = local.build_id
#   installer_version                   = "0.0.3"
#   key_pair_id                         = aws_key_pair.bifrost.id
#   log_group_name                      = data.aws_ssm_parameter.cloudwatch_log_group_name.value
#   name                                = local.build_id
#   onbase_version                      = var.onbase_version
#   service_account_password_secret_key = module.onbase_setup.onbase_domain_service_account_password_secret_arn
#   service_account_username            = module.onbase_setup.onbase_domain_service_account_username
#   subnet_id                           = split(",", data.aws_ssm_parameter.database_subnets.value)[0]
#   vpc_id                              = data.aws_ssm_parameter.vpc_id.value
# }

// Different subnets and vpc callings

# data "aws_region" "current" {}
# data "aws_ssm_parameter" "private_subnets" {
#   name = "/vpc/private_subnets"
# }
# data "aws_ssm_parameter" "public_subnets" {
#   name = "/vpc/public_subnets"
# }
# data "aws_ssm_parameter" "database_subnets" {
#   name = "/vpc/database_subnets"
# data "aws_ssm_parameter" "database_subnets" {
#   name = "/vpc/database_subnets"
# }

// RDS Database Config

provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.0.0"

#   name                 = "education"
#   cidr                 = "10.0.0.0/16"
#   azs                  = data.aws_availability_zones.available.names
#   public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
#   enable_dns_hostnames = true
#   enable_dns_support   = true
# }

// Database subnet groups

resource "aws_db_subnet_group" "education" {
  name       = "education"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "Education"
  }
}

resource "aws_security_group" "rds" {
  name   = "education_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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


// Security Groups Config
// Covered by Kamryn
// Site used: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

// Autoscaling security groups config
// Website used: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group

// vpc_alb
resource "aws_launch_template" "vpc_alb_sg" {
  name_prefix   = "vpc_alb_sg-as"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "vpc_alb" {
  availability_zones = ["us-east-2a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.vpc_alb_sg.id
    version = "$Latest"
  }
}

// ec2

resource "aws_launch_template" "ec2-g" {
  name_prefix   = "ec2-sg-as"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "ec2-as" {
  availability_zones = ["us-east-2a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.ec2-g.id
    version = "$Latest"
  }
}

// DB

resource "aws_launch_template" "rds" {
  name_prefix   = "rds-sg-as"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "rds-as" {
  availability_zones = ["us-east-2a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.rds.id
    version = "$Latest"
  }
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
