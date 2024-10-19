resource "aws_cloudwatch_event_rule" "rule" {
  name = var.name
  description = var.description
  schedule_expression = var.rule_expression
}

resource "aws_cloudwatch_event_target" "cloudwatch_event_target" {
  rule = aws_cloudwatch_event_rule.rule.name
  target_id = "lambda"
  arn = var.function_arn
}

resource "aws_lambda_permission" "cloudwatch_permission" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = var.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.rule.arn
}
