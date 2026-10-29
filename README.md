# 🚀 AWS Static Website Hosting with Terraform, S3, and CloudFront (OAC)

This project automates the deployment of a secure, highly available static website on AWS using **Terraform**. It implements modern AWS security best practices by completely blocking public access to the S3 bucket and routing all traffic exclusively through **Amazon CloudFront** using **Origin Access Control (OAC)**.

---

## 🏗️ Architecture Overview

1. **Amazon S3**: Stores the static website files (`index.html`, `style.css`, `script.js`, etc.) with public access blocked.
2. **Amazon CloudFront (CDN)**: Delivers content globally with HTTPS encryption (`redirect_to_https`) and utilizes **OAC** to securely authenticate requests to the S3 bucket.
3. **IAM Bucket Policy**: Restricts S3 bucket access strictly to the designated CloudFront Distribution via `aws:sourceArn`.

---
## 📂 Project Structure

``` text
├── provider.tf         # AWS provider and Terraform required versions
├── variables.tf        # Input variables (e.g., s3_bucket_name)
├── locals.tf           # Local values (e.g., origin_id and mime_types mapping)
├── main.tf             # Core resources (S3 bucket, public access block, OAC, bucket policy, S3 objects, and CloudFront distribution)
├── outputs.tf          # Output values (e.g., CloudFront distribution domain name)
└── www/                # Local directory containing website source files
    ├── index.html
    ├── style.css
    └── script.js