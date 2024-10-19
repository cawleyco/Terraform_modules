module "website_domain" {
  source      = "../modules/subdomain"
  zone_id     = var.dns_zone_id
  domain_name = var.domain_name
  environment = var.environment
}

module "doc_domain" {
  source      = "../modules/subdomain"
  zone_id     = var.dns_zone_id
  domain_name = "doc.${var.domain_name}"
  environment = "doc ${var.environment}"
}

module "api_domain" {
  source      = "../modules/subdomain"
  domain_name = "api.${var.domain_name}"
  zone_id     = var.dns_zone_id
  environment = "api ${var.environment}"
}

provider "aws" {
  region = "us-east-1" # Certificates for use with Cloudfront need to be in us-east-1
  alias  = "us-e-1"
}

# ssl cert to be used with api_domain
module "ssl_cert" {
  source = "../modules/sslcert"
  providers = {
    aws = aws.us-e-1
  }
  domain_name = "api.${var.domain_name}"
  alt_names   = []
  zone_id     = module.api_domain.zone_id
  environment = var.environment
}

resource "aws_api_gateway_domain_name" "custom_api_domain" {
  domain_name     = "api.${var.domain_name}"
  certificate_arn = module.ssl_cert.arn
}

# Example DNS record using Route53.
# Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "custom_api_domain_record" {
  zone_id = module.api_domain.zone_id # See aws_route53_zone for how to create this

  name = aws_api_gateway_domain_name.custom_api_domain.domain_name
  type = "A"

  alias {
    name                   = aws_api_gateway_domain_name.custom_api_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.custom_api_domain.cloudfront_zone_id
    evaluate_target_health = true
  }
}

