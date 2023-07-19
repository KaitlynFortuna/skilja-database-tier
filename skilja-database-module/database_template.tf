
// Initialize the database that isn't RDS

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









