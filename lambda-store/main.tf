resource "aws_s3_bucket" "lambda_store" {
  bucket = "${var.project}-lambda-store-${var.environment}"
  acl    = "private"

  tags = {
    Name        = "Lambda Store"
    Environment = var.environment
  }
}

###################################
# deploy-lambda function
###################################

locals {
  function_name = "${var.project}-deploy-lambda-${var.environment}"
}

resource "aws_lambda_function" "deploy-lambda" {
  function_name = local.function_name

  # The bucket name created by the initial infrastructure set up
  s3_bucket = "fathom-lambda-s3-trigger"
  s3_key    = "deploy-lambda.zip"

  # "index" is the filename within the zip file (index.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "index.handler"
  runtime = var.runtime
  timeout = 10

  role = aws_iam_role.deploy-lambda-role.arn

  environment {
    variables = {
      region       = var.region
      s3BucketName = "${var.project}-lambda-store-${var.environment}"
      project      = var.project
      stage        = var.environment
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:${var.region}:${var.account_id}:function:${var.project}-deploy-lambda-${var.environment}"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.project}-lambda-store-${var.environment}"

  depends_on = [
    aws_s3_bucket.lambda_store,
    aws_lambda_function.deploy-lambda,
  ]
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "deploy-lambda-role" {
  name = "${var.project}-deploy-lambda-role-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "deploy-lambda-policy" {
  name        = "${var.project}-deploy-lambda-policy-${var.environment}"
  description = ""
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "lambda:UpdateFunctionCode"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "deploy-lambda-attach" {
  role       = aws_iam_role.deploy-lambda-role.name
  policy_arn = aws_iam_policy.deploy-lambda-policy.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${var.project}-lambda-store-${var.environment}"

  lambda_function {
    lambda_function_arn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${var.project}-deploy-lambda-${var.environment}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "v1.0.0/"
    filter_suffix       = ".zip"
  }

  depends_on = [aws_lambda_function.deploy-lambda]
}

# This is to manage the CloudWatch Log Group for the Lambda Function.
resource "aws_cloudwatch_log_group" "log-group" {
  name              = "/aws/lambda/${local.function_name}" 
  retention_in_days = var.log_retention_in_days
}
