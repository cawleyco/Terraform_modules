resource "aws_route53_zone" "sub" {
  name = var.domain_name

  tags = {
    Environment = var.environment
  }
}

resource "aws_route53_record" "sub_ns" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "NS"
  ttl     = "30"

  records = [
    aws_route53_zone.sub.name_servers[0],
    aws_route53_zone.sub.name_servers[1],
    aws_route53_zone.sub.name_servers[2],
    aws_route53_zone.sub.name_servers[3],
  ]
}

