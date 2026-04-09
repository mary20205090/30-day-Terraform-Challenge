# Day 17 Manual Test Checklist

Use this checklist for both:

- `day_17/environments/dev`
- `day_17/environments/production`

## Provisioning Verification

- `terraform init` completes without errors
- `terraform validate` passes cleanly
- `terraform plan` shows the expected resource count and types
- `terraform apply` completes without errors

## Resource Correctness

- ALB, target group, ASG, launch template, SNS topic, and CloudWatch alarm exist
- names, tags, and region match the environment variables
- security groups contain only the expected rules

## Functional Verification

- ALB DNS name resolves
- `curl http://<alb-dns>` returns the expected response
- instances pass target group health checks
- stopping one instance causes the ASG to replace it

## State Consistency

- `terraform plan` returns no changes immediately after apply
- state matches what exists in AWS

## Regression Check

- make a tiny safe change such as a tag or description
- `terraform plan` shows only the expected diff
- apply it
- `terraform plan` returns clean afterward

## Cleanup

- `terraform plan -destroy` reviewed before destroy
- `terraform destroy` completes
- AWS post-destroy checks return empty results for active, non-terminated resources
