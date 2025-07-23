resource "aws_lambda_function" "processor" {
  function_name = "${var.project_name}-processor"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "data_processor.lambda_handler"

  s3_bucket         = "event-driven-pipeline-data-bucket"
  s3_key            = "lambda/data_processor.zip"   
  source_code_hash  = filebase64sha256("../lambda/data_processor.zip")

  environment {
    variables = {
      DB_USER = "admin"
    }
  }
}

resource "aws_lambda_function" "report_generator" {
  function_name = "${var.project_name}-report-generator"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "report_generator.lambda_handler"

  s3_bucket         = "event-driven-pipeline-data-bucket"
  s3_key            = "lambda/report_generator.zip"     # ✅ fixed this line
  source_code_hash  = filebase64sha256("../lambda/report_generator.zip")

  environment {
    variables = {
      DB_USER = "admin"
    }
  }
}

