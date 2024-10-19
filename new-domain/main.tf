module "new_domain" {
  source      = "../modules/subdomain"
  zone_id     = var.dns_zone_id
  domain_name = "${var.sub_domain}.${var.root_domain}"
  environment = "Base Domain"
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
  domain_name = "${var.sub_domain}.${var.root_domain}"
  alt_names   = []
  zone_id     = module.new_domain.zone_id
  environment = var.environment
}

