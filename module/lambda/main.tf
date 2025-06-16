locals {
  raw_source = "../../src/index.py"
  zip_source = "../../src/lambda_function_payload.zip"
}

#--------------------------------------------------------------
# Lambda
#--------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
data "archive_file" "lambda" {
  type        = "zip"
  source_file = local.raw_source
  output_path = local.zip_source
}

# Lambda関数の作成
resource "aws_lambda_function" "metadata_register" {
  function_name = var.app_name
  runtime       = "python3.9"
  handler       = "index.lambda_handler"
  memory_size   = 256
  timeout       = 30
  role          = aws_iam_role.lambda_execution_role.arn
  architectures = ["arm64"]

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_arn
    }
  }

  filename         = local.zip_source
  source_code_hash = filebase64sha256(local.zip_source)
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.metadata_register.function_name
  principal     = "s3.amazonaws.com"

  # S3バケット名を指定
  source_arn = var.s3_bucket_arn
}

# S3イベントトリガーの作成
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.metadata_register.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.allow_s3_invoke
  ]
}

#--------------------------------------------------------------
# IAM Role
#--------------------------------------------------------------
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.app_name}-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_to_s3_and_dynamodb" {
  name = "LambdaS3DynamoDBPolicy"
  role = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["dynamodb:PutItem", "dynamodb:GetItem", "dynamodb:Query", "dynamodb:TransactWriteItems"],
        Resource = "${var.dynamodb_table_arn}"
      },
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject"],
        Resource = "${var.s3_bucket_arn}/*"
      },
      {
        Effect   = "Allow",
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

#--------------------------------------------------------------
# CloudWatch
#--------------------------------------------------------------

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.app_name}"
  retention_in_days = 7
}