#
# This is a module that creates a static web site that is hosted in an S3 bucket.
#

#
# Create an S3 bucket to hold the web site artifacts
#

resource "aws_s3_bucket" "webstore" {
  bucket = "${var.root_domain}"
  acl    = "private"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
    Name = "Web Store ${var.root_domain}"
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
            "Resource": "arn:aws:s3:::${var.root_domain}/*"
        }
    ]
}
POLICY
}
