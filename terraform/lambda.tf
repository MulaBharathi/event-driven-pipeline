resource "aws_lambda_function" "processor" {
  function_name = "${var.project_name}-processor"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "data_processor.lambda_handler"

  filename         = "${path.module}/../lambda/data_processor.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/data_processor.zip")

  environment {
    variables = {
      DB_USER = var.db_user
    }
  }

  timeout     = 10
  memory_size = 128
}

resource "aws_lambda_function" "report_generator" {
  function_name = "${var.project_name}-report-generator"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "report_generator.lambda_handler"

  filename         = "${path.module}/../lambda/report_generator.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/report_generator.zip")

  environment {
    variables = {
      DB_USER = var.db_user
    }
  }

  timeout     = 10
  memory_size = 128
}
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data_bucket.arn  # replace with your S3 bucket resource name
}

resource "aws_s3_bucket_notification" "notify_lambda" {
  bucket = aws_s3_bucket.data_bucket.id  # replace with your S3 bucket resource name

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}

