output "s3_bucket_name" {
  value = aws_s3_bucket.static_website
}
output "cloudFront_distribution" {
  value = aws_cloudfront_distribution.s3_distribution
}