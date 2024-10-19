resource "aws_s3_bucket" "images_store" {
  bucket = "${var.project}-images-store-${var.environment}"
  acl    = "private"

  tags = {
    Name        = "${var.project} Images Store"
    Environment = var.environment
  }
}

output "images_store_name" {
  value = aws_s3_bucket.images_store.id
}

