module "static_website" {
  source = "../../modules/s3-static-website"

  bucket_name       = var.bucket_name
  environment       = var.environment
  index_document    = var.index_document
  error_document    = var.error_document
  enable_cloudfront = var.enable_cloudfront

  tags = {
    Owner = var.owner
    Day   = "25"
  }
}
