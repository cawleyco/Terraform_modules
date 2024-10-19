variable "dns_zone_id" {
  description = "The zone ID of the Route 53 zone within which the sub-domains are created"
}

variable "environment" {
  description = "Environment of the app e.g. dev, prod"
}

variable "root_domain" {
  description = "Top domain of the app e.g. beamabag.com"
  type        = string
}

variable "sub_domain" {
  description = "Top domain of the app e.g. beamabag, baggo"
  type        = string
}

