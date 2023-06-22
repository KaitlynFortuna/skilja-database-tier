# resource "aws_subnet" "public_subnet1" {

#   vpc_id = module.vpc.vpc_id

#   cidr_block = "10.0.1.0/27"

# }

# resource "aws_subnet" "public_subnet2" {

#   vpc_id = module.vpc.vpc_id

#   cidr_block = "10.0.2.0/27"

# }

# resource "aws_subnet" "private_subnet1" {

#   vpc_id = module.vpc.vpc_id

#   cidr_block = "10.0.32.0/19"

# }

# resource "aws_subnet" "private_subnet2" {

#   vpc_id = module.vpc.vpc_id

#   cidr_block = "10.0.64.0/19"

# }

// Communication from application to database
