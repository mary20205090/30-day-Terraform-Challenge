output "primary_region_name" {
  description = "Primary region used for the module deployment"
  value       = var.primary_region
}

output "replica_region_name" {
  description = "Replica region used for the module deployment"
  value       = var.replica_region
}

output "primary_bucket_name" {
  description = "Primary S3 bucket name created by the child module"
  value       = module.multi_region_app.primary_bucket_name
}

output "replica_bucket_name" {
  description = "Replica S3 bucket name created by the child module"
  value       = module.multi_region_app.replica_bucket_name
}
