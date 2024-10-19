variable "dns_zone_id" {
  description = "The zone ID of the Route 53 zone within which the domain id created"
  type = "string"
}

variable "domain_name" {
  type = "string"
}

variable "alias_count" {
  default = "1"
}

variable "aliases" {
  default = [""]
}

variable "environment" {
  type = "string"
}

