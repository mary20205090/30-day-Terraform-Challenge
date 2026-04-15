# Day 21 Infrastructure Safeguards

Infrastructure deploys need controls that most app deploys do not need.

## Destructive Change Approval

If a reviewed plan shows any destroys, pause before apply and require a second
explicit approval. In Terraform Cloud, this should be handled with a mandatory
apply approval gate for production workspaces.

## Plan File Pinning

Correct:

```bash
terraform -chdir=day_21/live/dev plan -out=day21.tfplan
terraform -chdir=day_21/live/dev apply day21.tfplan
```

This applies exactly the reviewed plan.

Risky:

```bash
terraform apply
```

This creates a fresh plan at apply time, which may differ from what reviewers
approved.

## State Backup

For production, use remote state with locking and S3 bucket versioning enabled.
Before major applies, know how to list previous state versions:

```bash
aws s3api list-object-versions \
  --bucket your-terraform-state-bucket \
  --prefix production/terraform.tfstate
```

## Blast Radius

Every infrastructure PR should say what depends on the resources being changed
and what breaks if apply fails halfway through. Shared resources like VPCs,
security groups, IAM roles, and databases need extra caution.
