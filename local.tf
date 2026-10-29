locals {
  origin_id = "s3_${aws_s3_bucket.static_website.id}"
  
//upload the files to the s3 bucket
  mime_types = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    json = "application/json"
    png  = "image/png"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    txt  = "text/plain"
    ico  = "image/x-icon"
    svg  = "image/svg+xml"
    gif  = "image/gif"
  }
}