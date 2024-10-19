variable "domain_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "zone_id" {
  type        = string
  description = "The Hosted Zone ID of the main domain"
}

