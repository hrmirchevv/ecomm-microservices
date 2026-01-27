resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.this.id
  availability_zone = "eu-north-1b"
  cidr_block        = "10.0.3.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet2"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "main-nat"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_lb" "app" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public.id, aws_subnet.public_2.id]
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "auth" {
  name     = "auth-tg"
  port     = 3002
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
}

resource "aws_lb_target_group" "customers" {
  name     = "customers-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    path                = "/customers"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "subscriptions" {
  name     = "subscriptions-tg"
  port     = 3001
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    path                = "/test"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code  = "404"
      content_type = "text/plain"
      message_body = "Not Found"
    }
  }
}

resource "aws_lb_listener_rule" "auth_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth.arn
  }
  condition {
    path_pattern { values = ["/auth", "/auth/*"] }
  }
}

resource "aws_lb_listener_rule" "customers_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 2
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.customers.arn
  }
  condition {
    path_pattern { values = ["/customers", "/customers/*"] }
  }
}

resource "aws_lb_listener_rule" "subscriptions_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 3
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.subscriptions.arn
  }
  condition {
    path_pattern { values = ["/subscriptions", "/subscriptions/*"] }
  }
}

# Attach EC2 backend instances to the target groupsye
resource "aws_lb_target_group_attachment" "auth" {
  target_group_arn = aws_lb_target_group.auth.arn
  target_id        = aws_instance.auth.id
  port             = 3002
}

resource "aws_lb_target_group_attachment" "customers" {
  target_group_arn = aws_lb_target_group.customers.arn
  target_id        = aws_instance.customers.id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "subscriptions" {
  target_group_arn = aws_lb_target_group.subscriptions.arn
  target_id        = aws_instance.subscriptions.id
  port             = 3001
}

