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
- using local state for this lab so everything can be destroyed after practice
- documenting the S3 + DynamoDB backend pattern in `backend.tf.example` as the production best practice

## Important Notes

- create the bootstrap secret manually in AWS Secrets Manager first
- never hardcode provider credentials in Terraform code
- keep `.terraform/`, `.terraform.lock.hcl`, `*.tfstate`, and `*.tfvars` out of Git
- this folder intentionally uses local state to match a destroy-after-each-lesson workflow
- in a real environment, state should live in a protected remote backend because it can still contain secrets in plaintext
- the best-practice backend example for this lesson is in `backend.tf.example`
