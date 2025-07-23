# Create the S3 bucket
resource "aws_s3_bucket" "pipeline_bucket" {
  bucket = "${var.project_name}-event-driven-pipeline-bucket"
  force_destroy = true

  tags = {
    Name        = "${var.project_name}-pipeline-bucket"
    Environment = var.environment
  }
}

# Upload report_generator Lambda ZIP
resource "aws_s3_object" "report_generator_zip" {
  bucket       = aws_s3_bucket.pipeline_bucket.id
  key          = "lambda/report_generator.zip"  # S3 path
  source       = "${path.module}/../lambda/report_generator.zip"  # local file path
  etag         = filemd5("${path.module}/../lambda/report_generator.zip")
  content_type = "application/zip"
}

# Upload data_processor Lambda ZIP
resource "aws_s3_object" "data_processor_zip" {
  bucket       = aws_s3_bucket.pipeline_bucket.id
  key          = "lambda/data_processor.zip"
  source       = "${path.module}/../lambda/data_processor.zip"
  etag         = filemd5("${path.module}/../lambda/data_processor.zip")
  content_type = "application/zip"
}

