module "main_website_domain" {
  source = "../../../modules/subdomain"
  zone_id = "${var.dns_zone_id}"
  domain_name = "${var.domain_name}"
  environment = "${var.environment}"
}

module "staging_website_domain" {
  source = "../../../modules/subdomain"
  zone_id = "${var.dns_zone_id}"
  domain_name = "staging.${var.domain_name}"
  environment = "${var.environment}"
}
