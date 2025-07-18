resource "aws_lambda_function" "processor" {
  function_name = "${var.project_name}-processor"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "lambda_code/data_processor.py"

  source_code_hash = filebase64sha256("lambda_code/data_processor.py")
  filename      = "lambda_code/data_processor.zip"

  source_code_hash = filebase64sha256("lambda_code/data_processor.zip")
  environment {
    variables = {
      DB_USER = "admin"
    }
  }
}

