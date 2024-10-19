variable "dns_zone_id" {
  description = "The zone ID of the Route 53 zone within which the sub-domains are created"
}

variable "domain_name" {
  description = "The domain of the website e.g. fathomgen.fathominnovation.com"
  type        = string
}

