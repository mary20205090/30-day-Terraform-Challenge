## What this changes

Adds a Day 21 CloudWatch alarm that watches the webserver ASG capacity. The alarm fires when the number of in-service instances drops below the desired capacity.

## Terraform plan output

Paste the output from:

```bash
terraform -chdir=day_21/live/dev show -no-color day21.tfplan
```

## Resources affected

- Created: 16
- Modified: 0
- Destroyed: 0

## Blast radius

Low for the alarm itself. The alarm depends on the ASG name and SNS topic, but it does not change traffic routing, security groups, launch templates, or instance capacity.

## Rollback plan

Revert this PR and apply the reviewed rollback plan. If the alarm is noisy but infrastructure is healthy, disable alarm actions temporarily in AWS while the Terraform rollback is reviewed.

## Safeguards checked

- `terraform fmt -check -recursive day_21`
- `terraform validate`
- `terraform test`
- saved plan file reviewed before apply
- no unexpected destroys
