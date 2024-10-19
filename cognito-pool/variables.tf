variable "name" {
  type        = string
  description = "The name for the cognito pool"
  default     = "user-pool"
}

variable "client_name" {
  type        = string
  description = "The name of the cognito pool's client"
  default     = "user-pool-client"
}

variable "allow_admin_create_user_only" {
  type        = string
  description = "Set to True if only the administrator is allowed to create user profiles"
  default     = "false"
}

