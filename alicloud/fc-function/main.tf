locals {
  function_name = "${var.function_name}-${var.stage}"
}

resource "alicloud_log_project" "logs" {
  name        = local.function_name
  description = "created by terraform"
}

resource "alicloud_log_store" "logs" {
  project               = alicloud_log_project.logs.name
  name                  = "fc-${local.function_name}"
  shard_count           = 3
  retention_period = var.log_retention_in_days
  auto_split            = true
  max_split_shard_count = 60
  append_meta           = true
}

resource "alicloud_fc_service" "default" {
  name        = local.function_name
  description = "Function compute service for ${local.function_name}"
  log_config {
    project  = alicloud_log_project.logs.name
    logstore = alicloud_log_store.logs.name
  }
#  role       = alicloud_ram_role.default.arn
#  depends_on = [alicloud_ram_role_policy_attachment.default]
}

resource "alicloud_fc_function" "function" {
  name = local.function_name
  service     = alicloud_fc_service.default.name

  oss_bucket = length(var.oss_bucket) > 0 ? var.oss_bucket : null
  oss_key = length(var.oss_key) > 0 ? var.oss_key : null

  handler = length(var.image_uri) > 0 ? null : "index.handler"
  runtime = length(var.image_uri) > 0 ? null : var.runtime
  timeout = var.timeout
  memory_size = var.memory_size
}


/*
resource "aws_lambda_function" "function" {
  function_name = local.function_name

  # The zip containing the lambda function
  filename = length(var.filename) > 0 ? var.filename : null
  source_code_hash = length(var.source_code_hash) > 0 ? var.source_code_hash : null
  image_uri = length(var.image_uri) > 0 ? var.image_uri : null

  # The bucket name created by the initial infrastructure set up
  s3_bucket = length(var.s3_bucket) > 0 ? var.s3_bucket : null
  s3_key = length(var.s3_key) > 0 ? var.s3_key : null

  # "index" is the filename within the zip file (index.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = length(var.image_uri) > 0 ? null : "index.handler"
  runtime = length(var.image_uri) > 0 ? null : var.runtime
  architectures = var.architectures
  timeout = var.timeout
  memory_size = var.memory_size


  dynamic "file_system_config" {
    for_each = var.file_system_config == "" ? [] : [var.file_system_config]
    content {
      arn = file_system_config.value["arn"]
      local_mount_path = file_system_config.value["local_mount_path"]
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config == "" ? [] : [var.vpc_config]
    content {
      subnet_ids = vpc_config.value["subnet_ids"]
      security_group_ids = vpc_config.value["security_group_ids"]
    }
  }

  role = aws_iam_role.role.arn

  // The run time environment dependencies (package.json & node_modules)
//  layers = [length(var.layer_id) > 0 ? var.layer_id : null]
  layers = var.layers

  package_type = length(var.image_uri) > 0 ? "Image" : "Zip"

  depends_on = [var.dependency_on, aws_cloudwatch_log_group.log-group]

  environment_variables = var.environment_variables
}
*/

/*
resource "aws_iam_role" "role" {
  name = "${var.function_name}-role-${var.stage}"

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
*/

/*
resource "aws_iam_policy" "policy" {
  name        = "${var.function_name}-policy-${var.stage}"
  description = ""
  policy = var.policy_statement
}
*/

/*
resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
*/


# resource "aws_lambda_permission" "apigw-permission" {
#   depends_on    = [aws_lambda_function.function]
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.function.arn
#   principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
#   source_arn = "${var.api_execution_arn}/*/*"

  # Prevent resource creation if var.apigw_permission_required is false
#   count = var.apigw_permission_required ? 1 : 0
# }

/*
# This is to manage the CloudWatch Log Group for the Lambda Function.
resource "aws_cloudwatch_log_group" "log-group" {
  name              = "/aws/lambda/${local.function_name}" 
  retention_in_days = var.log_retention_in_days
}
*/
