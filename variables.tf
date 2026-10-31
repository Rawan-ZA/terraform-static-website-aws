variable "s3_bucket_name" {
  default = "rawan-static-website-bucket"
}
variable "domain_name" {
  type        = string
  description = "Custom domain name for static website"
  default     = "Your_DomainName.com"
}