resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_name}-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "processor" {
  function_name = "${var.project_name}-processor"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "data_processor.lambda_handler"

  s3_bucket         = "event-driven-pipeline-data-bucket"
  s3_key            = "lambdas/data_processor.zip"
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
  s3_key            = "lambdas/report_generator.zip"
  source_code_hash  = filebase64sha256("../lambda/report_generator.zip")

  environment {
    variables = {
      DB_USER = "admin"
    }
  }
}

