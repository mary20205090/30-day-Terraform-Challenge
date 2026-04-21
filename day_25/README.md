# Day 25: Deploy a Static Website on AWS S3 with Terraform

Day 25 builds a complete static website stack with S3 and CloudFront. The exam prep continues in the background, but today returns to a practical infrastructure build using the habits from the previous days: reusable modules, environment isolation, variables, tags, remote state, reviewed plans, and cleanup.

## What This Builds

- S3 bucket configured for static website hosting.
- Public read policy for website objects.
- Optional CloudFront distribution in front of the S3 website endpoint.
- `index.html` and `error.html` uploaded by Terraform.
- Environment-specific dev configuration.
- Remote state configuration using S3 and DynamoDB.
- Cleanup-friendly `force_destroy` for non-production environments.

## Project Structure

```text
day_25/day25-static-website/
├── backend.tf
├── bootstrap/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── provider.tf
├── envs/
│   └── dev/
│       ├── backend.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── provider.tf
│       ├── terraform.tfvars
│       └── variables.tf
└── modules/
    └── s3-static-website/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

The root-level `backend.tf` and `provider.tf` document the project backend/provider setup. The runnable dev root module is under `envs/dev`, so the same backend/provider settings are repeated there. Terraform only reads `.tf` files in the directory where it is run.

The `bootstrap` folder exists because S3 backend resources must exist before Terraform can use them as a backend.

## Bootstrap Remote State

Run this once before initializing the dev environment:

```bash
cd day_25/day25-static-website/bootstrap
terraform init
terraform validate
terraform plan -out=bootstrap.tfplan
terraform apply bootstrap.tfplan
```

This creates:
- S3 bucket for Terraform state
- DynamoDB table for state locking
- S3 versioning and encryption for safer state storage

## How to Deploy Dev

From the repo root:

```bash
cd day_25/day25-static-website/envs/dev
terraform init -reconfigure
terraform validate
terraform plan -out=day25.tfplan
terraform apply day25.tfplan
```

If CloudFront is enabled, get the CloudFront URL:

```bash
terraform output -raw cloudfront_domain_name
```

Open:

```text
https://<cloudfront-domain-name>
```

CloudFront can take 5-15 minutes to finish global propagation. If AWS blocks new CloudFront distributions because the account is not verified yet, set `enable_cloudfront = false` in dev and verify the S3 website endpoint instead. The module remains CloudFront-ready for a verified account.

For the verified S3-only path, get the S3 website endpoint:

```bash
terraform output -raw website_endpoint
```

Open:

```text
http://<s3-website-endpoint>
```

S3 website endpoints are HTTP only. HTTPS requires CloudFront or another fronting layer.

## CloudFront Account Verification Finding

Terraform and the AWS Console both returned the same CloudFront blocker:

```text
AccessDenied: Your account must be verified before you can add new CloudFront resources.
```

This confirms the issue is not Terraform syntax, module design, or IAM policy in this repository. AWS is blocking new CloudFront distributions at the account/service level.

To keep the Day 25 lab moving safely:

- The module keeps CloudFront support behind `enable_cloudfront`.
- Dev sets `enable_cloudfront = false`.
- The S3 static website deployment can still be planned, applied, verified, and destroyed.
- Once AWS enables CloudFront for the account, set `enable_cloudfront = true`, run a fresh saved plan, and apply it.

To ask AWS to correct the account-level CloudFront blocker:

1. Open AWS Support Center: <https://console.aws.amazon.com/support/home#/>
2. Create a new support case.
3. Choose **Account and billing** support.
4. Use a subject such as `CloudFront account verification required`.
5. Include the AWS account ID and the full error message above.
6. Explain that the same error occurs in both Terraform and the AWS Console when creating a CloudFront distribution.

Example support message:

```text
Hello AWS Support,

I am trying to create an Amazon CloudFront distribution in account 718417034043.
Both Terraform and the AWS Console fail with this message:

"Your account must be verified before you can add new CloudFront resources."

Please verify or enable my account so I can create CloudFront distributions.
```

## Cleanup

Destroy after verification to avoid charges:

```bash
terraform plan -destroy -out=day25-destroy.tfplan
terraform apply day25-destroy.tfplan
```

The module uses:

```hcl
force_destroy = var.environment != "production"
```

This allows dev buckets with uploaded objects to be destroyed cleanly while protecting production from accidental object deletion.

## Optional Final Bootstrap Cleanup

The bootstrap backend creates the S3 state bucket and DynamoDB lock table. During normal work, keep these resources because they store remote state and protect against concurrent applies.

The committed bootstrap code intentionally keeps:

- S3 versioning enabled, because state history is valuable.
- `prevent_destroy = true`, because remote state should not be deleted accidentally.

For final lab cleanup only, destroy the dev website stack first. Then empty the versioned backend bucket before deleting it. This matters because a versioned S3 bucket can look empty in the console while still containing old object versions or delete markers.

Delete all object versions and delete markers:

```bash
aws s3api list-object-versions \
  --bucket mary-mutua-day25-terraform-state-718417034043 \
  --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}' \
  --output json > /tmp/day25-state-versions.json

aws s3api delete-objects \
  --bucket mary-mutua-day25-terraform-state-718417034043 \
  --delete file:///tmp/day25-state-versions.json

aws s3api list-object-versions \
  --bucket mary-mutua-day25-terraform-state-718417034043 \
  --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}' \
  --output json > /tmp/day25-state-delete-markers.json

aws s3api delete-objects \
  --bucket mary-mutua-day25-terraform-state-718417034043 \
  --delete file:///tmp/day25-state-delete-markers.json
```

Then temporarily replace the bootstrap bucket block in `bootstrap/main.tf` with a cleanup-only version:

```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.state_bucket_name
  force_destroy = true
  tags          = local.common_tags
}
```

Do not commit the cleanup-only version. The committed code should keep `prevent_destroy = true` and S3 versioning enabled.

Create and apply a fresh destroy plan:

```bash
terraform -chdir=day_25/day25-static-website/bootstrap plan -destroy -out=bootstrap-destroy-2.tfplan
terraform -chdir=day_25/day25-static-website/bootstrap apply bootstrap-destroy-2.tfplan
```

Verify cleanup:

```bash
aws s3api head-bucket --bucket mary-mutua-day25-terraform-state-718417034043
aws dynamodb describe-table --table-name terraform-state-locks-day25 --region us-east-1
```

Expected result after cleanup: both commands return `Not Found` style errors.

## Lab Result

Day 25 was completed with the S3 static website path.

- Bootstrap remote backend was created successfully: S3 state bucket plus DynamoDB lock table.
- Dev website plan showed `7 to add, 0 to change, 0 to destroy`.
- CloudFront creation was blocked by AWS account verification in both Terraform and the AWS Console.
- Dev was switched to `enable_cloudfront = false` so the S3 website endpoint could still be deployed and tested.
- The S3 website endpoint loaded successfully in the browser.
- Dev website resources were destroyed successfully: `6 destroyed`.
- Bootstrap backend cleanup required deleting S3 object versions/delete markers first because state bucket versioning was enabled.
- Final bootstrap destroy succeeded after version cleanup: `1 destroyed`.
- Post-cleanup checks returned `404 Not Found` for the state bucket and `ResourceNotFoundException` for the DynamoDB lock table.

## Day 25 Notes

- The S3 website endpoint is used as a CloudFront custom origin because S3 website hosting speaks HTTP, not HTTPS.
- CloudFront redirects viewers to HTTPS.
- `enable_cloudfront` exists because some AWS accounts must be verified before creating CloudFront distributions.
- Public bucket access is intentionally enabled for this static website lab.
- In production, a stronger pattern is CloudFront with private S3 origin access control where possible.
- `terraform.tfvars` contains only non-sensitive demo values. AWS credentials must stay in environment variables, profiles, or a secure runner.
