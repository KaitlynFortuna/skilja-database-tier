resource "aws_vpc" "my_vpc" {
  cidr_block = "10.10.0.0/19"
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.64.0/19"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "my_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "us-east-1a"
}

resource "aws_network_interface" "this1" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["10.10.10.100"]
}

resource "aws_network_interface" "this2" {
  subnet_id   = aws_subnet.my_subnet2.id
  private_ips = ["10.10.10.101"]
}

resource "aws_instance" "this" {
  ami           = "ami-c998b6b2"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.this1.id
    device_index         = 0
  }
}

resource "aws_instance" "this2" {
  ami           = "ami-c998b6b2"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.this2.id
    device_index         = 0
  }
}