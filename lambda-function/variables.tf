variable "stage" {}

variable "function_name" {}

variable "filename" {
  default = ""
}

variable "image_uri" {
  default = ""
}

variable "source_code_hash" {
  default = ""
}

variable "s3_bucket" {
  default = ""
}

variable "s3_key" {
  default = ""
}

variable "api_execution_arn" {
  default = ""
}

variable "dependency_on" {
  default = ""
}

variable "file_system_config" {
    default = ""
}

variable "vpc_config" {
    default = ""
}

variable "policy_statement" {}

variable "environment_variables" {}

variable "layers" {
  default = []
}

variable "memory_size" {
  default = 128
}

variable "timeout" {
  default = 10
}

variable "runtime" {
  default = "nodejs16.x"
}

variable "architectures" {
  default = ["x86_64"]
}

variable "log_retention_in_days" {
  default = 30
}

variable "apigw_permission_required" {
  default = true
}
