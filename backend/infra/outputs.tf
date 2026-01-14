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
