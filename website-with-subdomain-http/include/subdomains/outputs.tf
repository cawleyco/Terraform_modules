output "website_zone_id" {
  value = "${module.main_website_domain.zone_id}"
}

output "staging_zone_id" {
  value = "${module.staging_website_domain.zone_id}"
}
