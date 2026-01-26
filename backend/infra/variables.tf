variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "availability_zone" {
  description = "Primary AZ"
  type        = string
  default     = "eu-north-1a"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "my_ip" {
  description = "Your public IP for SSH access"
  type        = string
}

variable "db_username" {
  description = "Master DB username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Master DB password"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Postgres engine version"
  type        = string
  default     = "14"
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}
