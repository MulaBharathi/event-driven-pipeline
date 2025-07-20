variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_pass" {
  description = "The password for the RDS database admin user"
  type        = string
  sensitive   = true
}

variable "db_security_group_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "domain_name" {
  description = "The domain name for SES verification"
  type        = string
}

