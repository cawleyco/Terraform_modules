#
# This module creates an SSL certificate for a given domain
#

#
# Create an SSL certificate for the given domain
#
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.alt_names

  tags = {
    Environment = var.environment
  }
}

#
# This resource is used for AWS Certificate Manager verification via DNS
#
resource "aws_route53_record" "cert_verification" {
  zone_id = var.zone_id
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  ttl     = "30"

  records = [
    aws_acm_certificate.cert.domain_validation_options[0].resource_record_value,
  ]
}

#
# This resource is used for AWS Certificate Manager verification via DNS
#
resource "aws_route53_record" "cert_validation" {
  zone_id = var.zone_id
  name    = aws_acm_certificate.cert.domain_validation_options[1].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[1].resource_record_type
  ttl     = "30"

  records = [
    aws_acm_certificate.cert.domain_validation_options[1].resource_record_value,
  ]
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    aws_route53_record.cert_verification.fqdn,
    aws_route53_record.cert_validation.fqdn,
  ]
}

