resource "aws_instance" "frontend" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  key_name      = var.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.frontend.id
  ]

  user_data = templatefile("${path.module}/frontend-user-data.sh.tpl", {})

  tags = {
    Name = "frontend-react"
  }
}
