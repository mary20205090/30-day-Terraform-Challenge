locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "static-website"
  })
}

resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  # Dev and staging should clean up easily; production should not silently delete objects.
  force_destroy = var.environment != "production"

  tags = local.common_tags
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "website" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website.json

  depends_on = [aws_s3_bucket_public_access_block.website]
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = var.index_document
  content_type = "text/html"
  tags         = local.common_tags

  content = <<-HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Terraform Static Website</title>
      <style>
        body {
          font-family: Georgia, serif;
          margin: 0;
          min-height: 100vh;
          display: grid;
          place-items: center;
          background: linear-gradient(135deg, #f8efd4, #b7d7c7);
          color: #1d2b24;
        }
        main {
          max-width: 720px;
          padding: 3rem;
          border: 1px solid rgba(29, 43, 36, 0.18);
          border-radius: 28px;
          background: rgba(255, 255, 255, 0.72);
          box-shadow: 0 24px 60px rgba(29, 43, 36, 0.18);
        }
        h1 { font-size: clamp(2rem, 6vw, 4.5rem); margin: 0 0 1rem; }
        p { font-size: 1.15rem; line-height: 1.7; }
        code { background: #1d2b24; color: #f8efd4; padding: 0.2rem 0.45rem; border-radius: 8px; }
      </style>
    </head>
    <body>
      <main>
        <h1>Deployed with Terraform</h1>
        <p>${var.enable_cloudfront ? "This static site is served from S3 and distributed globally with CloudFront." : "This static site is served from the S3 website endpoint while CloudFront waits for AWS account verification."}</p>
        <p>Environment: <code>${var.environment}</code></p>
        <p>Bucket: <code>${var.bucket_name}</code></p>
      </main>
    </body>
    </html>
  HTML
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website.id
  key          = var.error_document
  content_type = "text/html"
  tags         = local.common_tags

  content = <<-HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>404 - Not Found</title>
    </head>
    <body>
      <h1>404 - Page Not Found</h1>
      <p>The requested page does not exist.</p>
    </body>
    </html>
  HTML
}

resource "aws_cloudfront_distribution" "website" {
  count = var.enable_cloudfront ? 1 : 0

  enabled             = true
  default_root_object = var.index_document
  price_class         = "PriceClass_100"
  tags                = local.common_tags

  origin {
    domain_name = aws_s3_bucket_website_configuration.website.website_endpoint
    origin_id   = "s3-website"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-website"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [
    aws_s3_bucket_policy.website,
    aws_s3_object.index,
    aws_s3_object.error
  ]
}
