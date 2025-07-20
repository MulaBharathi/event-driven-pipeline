variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "event-driven-pipeline"
}

variable "db_pass" {
  description = "The password for the RDS database admin user"
  type        = string
  sensitive   = true
}
variable "db_user" {
  description = "Database username"
  type        = string
}

variable "domain_name" {
  description = "The domain name for SES verification"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}
variable "db_security_group_id" {
  description = "The security group ID to associate with the RDS instance"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

