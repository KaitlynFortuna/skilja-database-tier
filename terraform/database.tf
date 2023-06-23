
// Initialize the database

module "database" {
  source = "git@github.com:HylandSoftware/terraform-aws-onbase-database.git"

  default_configuration_script        = "OnBaseDefaultConfiguration"
  directory_admin_secret_key          = data.aws_secretsmanager_secret.ad_adsecret.arn
  directory_id                        = data.aws_ssm_parameter.active_directory_id.value
  fsx_machine_name                    = data.aws_ssm_parameter.fsx_dns_name.value
  fsx_powershell_endpoint             = data.aws_ssm_parameter.fsx_admin_endpoint.value
  fsx_share_name                      = local.build_id
  installer_version                   = "0.0.3"
  key_pair_id                         = aws_key_pair.bifrost.id
  log_group_name                      = data.aws_ssm_parameter.cloudwatch_log_group_name.value
  name                                = local.build_id
  onbase_version                      = var.onbase_version
  service_account_password_secret_key = module.onbase_setup.onbase_domain_service_account_password_secret_arn
  service_account_username            = module.onbase_setup.onbase_domain_service_account_username
  subnet_id                           = split(",", data.aws_ssm_parameter.database_subnets.value)[0]
  vpc_id                              = data.aws_ssm_parameter.vpc_id.value
}

// Different subnets and vpc callings

data "aws_region" "current" {}

data "aws_ssm_parameter" "vpc_id" {
  name = "/vpc/vpc_id"
}
data "aws_ssm_parameter" "vpc_cidr" {
  name = "/vpc/vpc_cidr_block"
}
data "aws_ssm_parameter" "private_subnets" {
  name = "/vpc/private_subnets"
}
data "aws_ssm_parameter" "public_subnets" {
  name = "/vpc/public_subnets"
}
data "aws_ssm_parameter" "database_subnets" {
  name = "/vpc/database_subnets"
}

// RDS Database Config

resource "aws_rds_db_instance" "my_database" {
  name              = "my_database"
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  storage_type      = "gp2"
  username          = "root"
  password          = "password"
}

// RDS Database Config

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "demodb"

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3a.large"
  allocated_storage = 5

  db_name  = "demodb"
  username = "user"
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["sg-12345678"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = ["subnet-12345678", "subnet-87654321"]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}

# module "db" {
#   source = "terraform-aws-modules/rds/aws"

#   # Disable creation of RDS instance(s)
#   create_db_instance = false

#   # Disable creation of option group - provide an option group or default AWS default
#   create_db_option_group = false

#   # Disable creation of parameter group - provide a parameter group or default to AWS default
#   create_db_parameter_group = false

#   # Enable creation of subnet group (disabled by default)
#   create_db_subnet_group = true

#   # Enable creation of monitoring IAM role
#   create_monitoring_role = true

#   # ... omitted
# }

// Security Groups Config
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
