resource "aws_s3_bucket" "data_bucket" {
  bucket = "${var.project_name}-data-bucket"
  force_destroy = true
}

