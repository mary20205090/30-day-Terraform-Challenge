region         = "us-east-1"
bucket_name    = "mary-mutua-day25-static-website-dev-718417034043"
environment    = "dev"
index_document = "index.html"
error_document = "error.html"
owner          = "terraform-challenge"

# AWS currently blocks new CloudFront distributions until the account is verified.
# The module stays CloudFront-ready, but dev can still verify the S3 website path.
enable_cloudfront = false
