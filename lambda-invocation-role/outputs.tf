output "role_arn" {
  value = aws_iam_role.invocation-role.arn
}

output "policy_id" {
  value = aws_iam_role_policy.invocation-policy.id
}
