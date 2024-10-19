variable "dns_zone_id" {
  description = "The zone ID of the Route 53 zone within which the sub-domains are created"
}

variable "domain_name" {
  description = "Name of the domain e.g. project.fathominnovation.com"
  type        = string
}

variable "environment" {
  description = "Name of the domain e.g. project.fathominnovation.com"
  type        = string
}

