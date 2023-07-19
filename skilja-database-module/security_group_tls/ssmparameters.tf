# resource "aws_ssm_parameter" "database_subnets" {

#   name = "/vpc/database_subnets${var.unique_id}-database_subnets"

#   type = "String"

#   value = module.db_instance.database_subnets_id

# }

# resource "aws_ssm_parameter" "database_subnets_cidr_block" {

#   name = "/vpc/database_subnets_cidr_block${var.unique_id}-database_subnets_cidr_block"

#   type = "String"

#   value = module.db_instance.database_subnets_cidr_block_id

# }
