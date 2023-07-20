resource "aws_ssm_parameter" "rds_security_group_id" {

  name = "/run/${var.unique_id}/rds/rds_security_group_id"

  type = "String"

  value = aws_security_group.rds.id

}
