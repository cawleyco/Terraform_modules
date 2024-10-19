variable "api_id" {}

variable "lambda_invoke_arn" {}

variable "description" {
  default = ""
}

variable "route" {}

variable "authorizer_function_id" {
  default = ""
}

variable "authorization_type" {
  default = ""
}

variable "uses_authorizer" {
  default = ""
}
