data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "auth" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  key_name               = var.key_name
  vpc_security_group_ids = [
    aws_security_group.services.id,
    aws_security_group.ssh.id
  ]

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "auth-service"
  }
}

resource "aws_instance" "customers" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  key_name               = var.key_name
  vpc_security_group_ids = [
    aws_security_group.services.id,
    aws_security_group.ssh.id
  ]

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "customers-service"
  }
}

resource "aws_instance" "subscriptions" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  key_name               = var.key_name
  vpc_security_group_ids = [
    aws_security_group.services.id,
    aws_security_group.ssh.id
  ]

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "subscriptions-service"
  }
}
