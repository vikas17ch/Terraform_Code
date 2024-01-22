provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "Anil_vpc" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
    Name = "AnilVPC"
  }
}

resource "aws_internet_gateway" "Anil_igw" {
  vpc_id = aws_vpc.Anil_vpc.id

  tags = {
    Name = "AnilIGW"
  }
}

resource "aws_route_table" "Anil_public_route" {
  vpc_id = aws_vpc.Anil_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Anil_igw.id
  }

  tags = {
    Name = "AnilPublicRouteTable"
  }
}

resource "aws_subnet" "Anil_public_subnet" {
  vpc_id                  = aws_vpc.Anil_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "AnilPublicSubnet"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "AnilSecurityGroup"
  description = "Allow SSH traffic from my public IP"
  vpc_id      = aws_vpc.Anil_vpc.id

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

resource "aws_instance" "Anil_ec2_instance" {
  ami                          = "ami-0cd3c7f72edd5b06d"
  instance_type                = "t2.micro"
  key_name                     = "Kumar"
  vpc_security_group_ids       = [aws_security_group.my_security_group.id]
  subnet_id                    = aws_subnet.Anil_public_subnet.id
  associate_public_ip_address  = true

  tags = {
    Name = "AnilEC2Instance"
  }
}

resource "aws_route_table_association" "Anil_subnet_association" {
  subnet_id      = aws_subnet.Anil_public_subnet.id
  route_table_id = aws_route_table.Anil_public_route.id
}
