variable "domain_name" {
  type        = string
  description = "The name of the domain for which we are creating a certificate"
  default     = "prod.traveltechlabs.com"
}

variable "zone_id" {
  type        = string
  description = "The zone ID of the domain for which we are creating the certificate"
}

variable "alt_names" {
  type        = list(string)
  description = "A list of alternative domain names covered by this certificate"
}

variable "environment" {
  type = string
}

