# Day 13: Managing Sensitive Data Securely in Terraform

Day 13 focuses on the three places secrets leak in Terraform and the patterns that reduce those risks.

## Three Secret Leak Paths

1. Hardcoded in `.tf` files  
   If a password is written directly in a resource or variable default, it is committed to Git history.

2. Passed as a variable default  
   A secret in `default = "..."` is still plain text in source control.

3. Stored in Terraform state  
   Even when secrets come from Secrets Manager or environment variables, Terraform can still store them in plaintext in state.

## What This Folder Demonstrates

- reading database credentials from AWS Secrets Manager with data sources
- decoding the secret JSON with `jsondecode`
- passing the secrets to an RDS instance at apply time
- marking secret-related values as `sensitive = true`
- using a real S3 + DynamoDB remote backend so the state-file risk is covered live
- creating backend infrastructure first in `day_13/bootstrap`

## Important Notes

- create the bootstrap secret manually in AWS Secrets Manager first
- never hardcode provider credentials in Terraform code
- keep `.terraform/`, `.terraform.lock.hcl`, `*.tfstate`, and `*.tfvars` out of Git
- run `day_13/bootstrap` first to create the S3 bucket and DynamoDB lock table
- this lesson still supports a full cleanup workflow because the backend resources are dedicated to Day 13
- destroy order matters: destroy `day_13` first, then destroy `day_13/bootstrap`
