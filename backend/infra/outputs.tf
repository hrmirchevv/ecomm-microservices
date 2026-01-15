output "project" {
  value = var.project_name
}

output "auth_private_ip" {
  value = aws_instance.auth.private_ip
}

output "customers_private_ip" {
  value = aws_instance.customers.private_ip
}

output "subscriptions_private_ip" {
  value = aws_instance.subscriptions.private_ip
}

output "customers_db_host" {
  value = aws_db_instance.customers_db.address
}

output "subscriptions_db_host" {
  value = aws_db_instance.subscriptions_db.address
}

output "auth_db_host" {
  value = aws_db_instance.auth_db.address
}

output "frontend_public_ip" {
  value = aws_instance.frontend.public_ip
}

