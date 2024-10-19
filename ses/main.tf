resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.domain_name
}

resource "aws_route53_record" "amazonses_verification_record" {
  zone_id = var.dns_zone_id
  name    = "_amazonses.${var.domain_name}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.ses_domain.verification_token]
}

