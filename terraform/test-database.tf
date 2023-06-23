
# Database Module
# RDS Database
# RDS Modules
# Security Groups (monitor traffic going in and out) [reference Kamryn]
# Make ports variables
# Look into autoscalling groups (Something to think about)
# Make sure connection to application (communication) is open [security groups]

resource "aws_rds_db_instance" "example" {
  name           = "my-database"
  engine         = "mysql"
  instance_class = "db.t2.micro"
  username       = "root"
  password       = "mypassword"
} 
