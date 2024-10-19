#
# This is a module that creates a static web site that is hosted in an S3 bucket.
# It is assumed that the web site is only accessible via "https".
# A cloudfront distribution is created to cache the web access to the S3 bucket
# and an SSL certificate is created for the site.
#

#
# Create an S3 bucket to hold the web site artifacts
#

resource "aws_s3_bucket" "webstore" {
  bucket = "${var.domain_name}"
  acl    = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name = "Web Store ${var.domain_name}"
  }
}

#
# Create a resource policy for the S3 bucket to allow it to be retrieved
#
resource "aws_s3_bucket_policy" "webstore" {
  bucket = "${aws_s3_bucket.webstore.id}"
  policy =<<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPerm",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.domain_name}/*"
        }
    ]
}
POLICY
}

#
# Create a cloudfront distribution for the web site
#
resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "${var.domain_name} - Default Origin Access Identity"
}

resource "aws_cloudfront_distribution" "web_distribution" {
//  Waits for ssl cert to be validated
  depends_on = ["aws_s3_bucket.webstore"]

  origin {
    domain_name = "${aws_s3_bucket.webstore.website_endpoint}"
    origin_id   = "origin-bucket-${aws_s3_bucket.webstore.id}"

    # custom_origin_config {
    #   http_port = "80"
    #   # https_port = "443"
    #   origin_protocol_policy = "http-only"
    #   origin_ssl_protocols = [
    #     "TLSv1.2"
    #   ]
    # }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Cloudfront distribution for web store ${var.domain_name}"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin-bucket-${aws_s3_bucket.webstore.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "allow-all"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  aliases = "${var.aliases}"

  tags = {
    Environment = "${var.environment}"
    Name = "${var.domain_name}"
  }
}

#
# Set up A record(s) for the domain(s) that point to cloudfront
#
resource "aws_route53_record" "root_domain" {
  depends_on = ["$module.ssl_cert"]
  count = "${var.alias_count}"
  zone_id = "${var.dns_zone_id}"
  name = "${element(var.aliases, count.index)}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.web_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.web_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

provider aws {
  region = "us-east-1"      # Certificates for use with Cloudfront need to be in us-east-1
  alias = "us-e-1"
}

# module "ssl_cert" {
#   source = "../../../modules/sslcert"
#   providers = {
#     aws = "aws.us-e-1"
#   }
#   domain_name = "${var.domain_name}"
#   alt_names = "${slice(var.aliases, 1, length(var.aliases))}"
#   environment = "${var.environment}"
# //  This can be changed to add root domain or parent domain
#   zone_id = "${var.dns_zone_id}"
# }
