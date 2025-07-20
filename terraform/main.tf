module "networking" {
  source = "./networking"

  project_name          = var.project_name
  aws_region            = var.aws_region
  vpc_id                = var.vpc_id
  private_subnet_ids    = var.private_subnet_ids
  db_user               = var.db_user
  db_pass               = var.db_pass
  db_security_group_id  = var.db_security_group_id
  domain_name           = var.domain_name
}

