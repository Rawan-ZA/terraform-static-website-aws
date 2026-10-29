resource "aws_s3_bucket" "static_website" {
  bucket = var.s3_bucket_name
}
//block public access to the bucket
resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.static_website.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// connect the bucket to cloudfront using origin access control 
resource "aws_cloudfront_origin_access_control" "OAC" {
  name                              = "static-website-oac"
  description                       = "Access control for static website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

//add resource policy to the bucket to allow cloudfront access
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket     = aws_s3_bucket.static_website.id
  depends_on = [aws_s3_bucket_public_access_block.block]
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowOnlyCloudFrontToAccessS3Bucket",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"

        },
        "Action" : [
          "s3:GetObject",
        ],
        "Resource" : "${aws_s3_bucket.static_website.arn}/*",
        "Condition" : {
          "ArnEquals" : {
            "aws:sourceArn" : aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
    }
  )
}

resource "aws_s3_object" "objects" {
  //using it because we want to upload all the files in the www folder to the s3 bucket
  for_each = fileset("${path.module}/www", "**/*")
  bucket   = aws_s3_bucket.static_website.id
  key      = each.value
  source   = "${path.module}/www/${each.value}"
  etag     = filemd5("${path.module}/www/${each.value}")
  //automatically define the type of file
  content_type = lookup(
    local.mime_types, element(split(".", each.value), length(split(".", each.value)) - 1), "application/octet-stream"
  )
}
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.OAC.id
    origin_id                = local.origin_id
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect_to_https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
  cloudfront_default_certificate = true

  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "some Comments"
  price_class = "PriceClass_100"

}

