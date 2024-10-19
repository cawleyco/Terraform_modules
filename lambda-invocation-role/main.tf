resource "aws_iam_role" "invocation-role" {
  name = "${var.function_name}-invocation-role-${var.stage}"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invocation-policy" {
  name = "${var.function_name}-invocation-policy-${var.stage}"
  role = aws_iam_role.invocation-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${var.function_arn}"
    }
  ]
}
EOF
}
