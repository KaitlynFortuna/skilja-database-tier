resource "aws_security_group" "rds" {
  name   = "${var.unique_id}-sg"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "egress_group" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.rds.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_group" {
  type              = "ingress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.rds.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_db_parameter_group" "name" {
  name   = "name"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}
