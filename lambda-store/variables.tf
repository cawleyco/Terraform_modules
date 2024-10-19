variable "environment" {
  description = "The environment of the app e.g dev,demo,etc"
}

variable "project" {
  description = "The subdomain or project name of the app e.g. baggo, loyalty-system etc"
}

variable "account_id" {
  description = "AWS Account ID to deploy trigger"
}

variable "region" {
  description = "Region of AWS account"
}

variable "runtime" {
  description = "Lambda runtime version"
  default     = "nodejs14.x"
}

variable "log_retention_in_days" {
  default = 30
}
