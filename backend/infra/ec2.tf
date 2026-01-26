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
  subnet_id              = aws_subnet.public.id
  key_name               = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.services.id,
    aws_security_group.ssh.id
  ]

  user_data = templatefile("${path.module}/user-data.sh.tpl", {
    customers_db_host     = aws_db_instance.customers_db.address
    subscriptions_db_host = aws_db_instance.subscriptions_db.address
    auth_db_host          = aws_db_instance.auth_db.address
  })

  tags = {
    Name = "auth-service"
  }
}

resource "aws_instance" "customers" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  key_name               = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20  # 20 GB root volume
  }

  vpc_security_group_ids = [
    aws_security_group.services.id,
    aws_security_group.ssh.id
  ]

  user_data = templatefile("${path.module}/user-data.sh.tpl", {
    customers_db_host     = aws_db_instance.customers_db.address
    subscriptions_db_host = aws_db_instance.subscriptions_db.address
    auth_db_host          = aws_db_instance.auth_db.address
  })

  tags = {
    Name = "customers-service"
  }
}

resource "aws_instance" "subscriptions" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  key_name               = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20  # 20 GB root volume
  }

  vpc_security_group_ids = [
    aws_security_group.services.id,
    aws_security_group.ssh.id
  ]

  user_data = templatefile("${path.module}/user-data.sh.tpl", {
    customers_db_host     = aws_db_instance.customers_db.address
    subscriptions_db_host = aws_db_instance.subscriptions_db.address
    auth_db_host          = aws_db_instance.auth_db.address
  })

  tags = {
    Name = "subscriptions-service"
  }
}
