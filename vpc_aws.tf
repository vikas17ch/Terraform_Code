provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vikas_vpc" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
    Name = "vikasVPC"
  }
}

resource "aws_internet_gateway" "vikas_igw" {
  vpc_id = aws_vpc.vikas_vpc.id

  tags = {
    Name = "vikasIGW"
  }
}

resource "aws_route_table" "vikas_public_route" {
  vpc_id = aws_vpc.vikas_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vikas_igw.id
  }

  tags = {
    Name = "vikasPublicRouteTable"
  }
}

resource "aws_subnet" "vikas_public_subnet" {
  vpc_id                  = aws_vpc.vikas_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "vikasPublicSubnet"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "vikasSecurityGroup"
  description = "Allow SSH traffic from my public IP"
  vpc_id      = aws_vpc.vikas_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "vikas_ec2_instance" {
  ami                          = "ami-0005e0cfe09cc9050"
  instance_type                = "t2.micro"
  key_name                     = "splunk"
  vpc_security_group_ids       = [aws_security_group.my_security_group.id]
  subnet_id                    = aws_subnet.vikas_public_subnet.id
  associate_public_ip_address  = true

  tags = {
    Name = "vikasEC2Instance"
  }
}

resource "aws_route_table_association" "vikas_subnet_association" {
  subnet_id      = aws_subnet.vikas_public_subnet.id
  route_table_id = aws_route_table.vikas_public_route.id
}
