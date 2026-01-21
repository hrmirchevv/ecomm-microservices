# Customers DB
resource "aws_db_instance" "customers_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  identifier           = "customersdb"
  db_name              = "customersdb"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_public_subnets.name
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot  = true
  publicly_accessible  = true
  multi_az             = false
  deletion_protection  = false
  tags = {
    Name = "customers-db"
  }
}

# Subscriptions DB
resource "aws_db_instance" "subscriptions_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  identifier           = "subscriptionsdb"
  db_name              = "subscriptionsdb"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_public_subnets.name
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot  = true
  publicly_accessible  = true
  multi_az             = false
  deletion_protection  = false
  tags = {
    Name = "subscriptions-db"
  }
}

# Auth DB
resource "aws_db_instance" "auth_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  db_name              = "authdb"
  identifier           = "authdb"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_public_subnets.name
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot  = true
  publicly_accessible  = true
  multi_az             = false
  deletion_protection  = false
  tags = {
    Name = "auth-db"
  }
}

resource "aws_db_subnet_group" "db_subnets" {
  name = "${var.project_name}-${var.environment}-db-subnets"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "db-subnets"
  }
}

resource "aws_db_subnet_group" "db_public_subnets" {
  name = "${var.project_name}-${var.environment}-db-public-subnets"

  subnet_ids = [
    aws_subnet.public.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "db-public-subnets"
  }
}