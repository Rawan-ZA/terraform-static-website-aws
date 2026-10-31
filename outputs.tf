output "s3_bucket_name" {
  value = aws_s3_bucket.static_website.id
}
output "cloudFront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}