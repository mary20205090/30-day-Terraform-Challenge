# Day 22 Integrated Workflow

This folder combines the workflow lessons from Days 16-21 into one Day 22
staging stack.

## What is included

- Version-controlled Terraform code in `day_22`
- Reusable modules under `day_22/modules`
- A standalone staging root under `day_22/live/staging`
- Remote backend examples for S3/DynamoDB and Terraform Cloud
- GitHub Actions CI that runs `fmt`, `validate`, `terraform test`, and `plan`
- Uploaded `ci.tfplan` artifact for review
- Sentinel policy examples for instance type, required tags, and cost control

## Safe local workflow

```bash
terraform -chdir=day_22/live/staging init
terraform -chdir=day_22/live/staging validate
terraform -chdir=day_22/modules/services/webserver-cluster init -backend=false
terraform -chdir=day_22/modules/services/webserver-cluster test
terraform -chdir=day_22/live/staging plan -out=day22.tfplan
terraform -chdir=day_22/live/staging show -no-color day22.tfplan
```

Only apply after the plan has been reviewed:

```bash
terraform -chdir=day_22/live/staging apply day22.tfplan
```

Destroy immediately after the lab:

```bash
terraform -chdir=day_22/live/staging destroy
```

## Cleanup verification

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Project,Values=day22-integrated-workflow" \
            "Name=instance-state-name,Values=pending,running,stopping,stopped" \
  --query "Reservations[*].Instances[*].InstanceId"

aws elbv2 describe-load-balancers \
  --query "LoadBalancers[?contains(LoadBalancerName, 'day22')].LoadBalancerArn"
```
