# resource "aws_ssm_parameter" "private_subnets" {

#   name = "/vpc/private_subnets${var.unique_id}-private_subnets"

#   type = "String"

#   value = module.db_instance.private_subnets_id

# }
