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
