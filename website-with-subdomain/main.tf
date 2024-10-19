#
# This is the main terrafrom file for the infrastructure
# It uses modules in the include directory as a form of psuedo-include,
# so that this file can be relatively simple pulling in what is needed
# in sequence.
#

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Set up an explicit provider for US East 1 since certificates associated with Cloudfront must be set up there
provider "aws" {
  region = "us-east-1"
  alias  = "us-e-1"
}

module "subdomains" {
  source      = "./include/subdomains"
  dns_zone_id = var.dns_zone_id
  domain_name = var.domain_name
  environment = var.environment
}

#
# Set up the static website for the top and www domain
#
module "main_website" {
  source      = "./include/website"
  dns_zone_id = module.subdomains.website_zone_id
  domain_name = var.domain_name
  alias_count = "2"
  aliases     = [var.domain_name, "www.${var.domain_name}"]
  environment = var.environment
}

#
# Set up the static staging website
#
module "staging_website" {
  source      = "./include/website_staging"
  domain_name = "staging.${var.domain_name}"
}

