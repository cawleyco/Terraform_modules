variable "dns_zone_id" {
  description = "The zone ID of the Route 53 zone within which the sub-domains are created"
}

variable "root_domain" {
  type = string
}

variable "alias_count" {
  default = "1"
}

variable "aliases" {
  default = [""]
}

variable "environment" {
  type = string
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

