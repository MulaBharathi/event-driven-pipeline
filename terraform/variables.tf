variable "aws_region" {
  default = "ap-south-1"
}

variable "project_name" {
  default = "event-driven-pipeline"
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_pass" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "The domain name for SES verification"
  type        = string
}

