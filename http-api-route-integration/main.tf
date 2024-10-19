resource "aws_apigatewayv2_integration" "integration" {
  api_id = var.api_id
  integration_type = "AWS_PROXY"
  connection_type = "INTERNET"
  description = length(var.description) > 1 ? var.description : null
  integration_method = "POST"
  integration_uri = var.lambda_invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "route" {
  api_id = var.api_id
  route_key = var.route
  target = "integrations/${aws_apigatewayv2_integration.integration.id}"
  authorization_type = length(var.authorization_type) > 0 ? var.authorization_type : null
  authorizer_id = length(var.authorizer_function_id) > 1 ? var.authorizer_function_id : null
}
