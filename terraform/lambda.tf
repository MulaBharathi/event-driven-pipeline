resource "aws_lambda_function" "processor" {
  function_name = "${var.project_name}-processor"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "data_processor.lambda_handler"

  s3_bucket         = aws_s3_bucket.pipeline_bucket.bucket
  s3_key            = "lambda/data_processor.zip"
  source_code_hash  = filebase64sha256("${path.module}/../lambda/data_processor.zip")

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

  s3_bucket         = aws_s3_bucket.pipeline_bucket.bucket
  s3_key            = "lambda/report_generator.zip"
  source_code_hash  = filebase64sha256("${path.module}/../lambda/report_generator.zip")

  environment {
    variables = {
      DB_USER = var.db_user
    }
  }

  timeout     = 10
  memory_size = 128
}

# Allow S3 to invoke the processor Lambda function
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.pipeline_bucket.arn
}

# S3 bucket notification to trigger the processor Lambda on object creation
resource "aws_s3_bucket_notification" "notify_lambda" {
  bucket = aws_s3_bucket.pipeline_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}

# CloudWatch Event Rule to trigger the report_generator Lambda daily
resource "aws_cloudwatch_event_rule" "daily_report" {
  name                = "${var.project_name}-daily-report"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "invoke_report_generator" {
  rule      = aws_cloudwatch_event_rule.daily_report.name
  target_id = "ReportGenerator"
  arn       = aws_lambda_function.report_generator.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_report_generator" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.report_generator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_report.arn
}

