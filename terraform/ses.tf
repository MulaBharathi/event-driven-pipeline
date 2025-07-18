resource "aws_ses_domain_identity" "this" {
  domain = var.domain_name
}

resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}

output "ses_domain_identity_arn" {
  value = aws_ses_domain_identity.this.arn
}

