variable "aws_region" {
  description = "The AWS region for deployment"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to use"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "db_user" {
  description = "RDS username"
  type        = string
}

variable "db_pass" {
  description = "RDS password"
  type        = string
  sensitive   = true
}

variable "db_security_group_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "domain_name" {
  description = "Domain for SES"
  type        = string
}
variable "environment" {
  description = "The environment name (e.g. dev, prod)"
  type        = string
  default     = "dev"
}
# Lambda S3 keys
variable "lambda_report_key" {
  description = "S3 object key for report generator Lambda"
  type        = string
  default     = "lambda/report_generator.zip"
}

variable "lambda_processor_key" {
  description = "S3 object key for data processor Lambda"
  type        = string
  default     = "lambda/data_processor.zip"
}

