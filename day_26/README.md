# Day 26: Build a Scalable Web Application with Auto Scaling on AWS

Today moves from static website hosting to dynamic compute. The goal is a reusable Terraform project that deploys an Application Load Balancer, an EC2 Launch Template, an Auto Scaling Group, CPU-based scaling policies, CloudWatch alarms, and a dashboard.

The project keeps Day 26 resources separate from earlier days and carries forward the habits from Days 16-25: reusable modules, remote state, saved plans, validation, tagging, least-privilege network flow, and cleanup verification.

## Project Structure

```text
day26-scalable-web-app/
├── bootstrap/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── modules/
│   ├── alb/
│   ├── asg/
│   └── ec2/
├── envs/
│   └── dev/
├── backend.tf
└── provider.tf
```

`bootstrap/` creates the S3 backend bucket and DynamoDB lock table. `envs/dev/` is the active root module that calls the reusable EC2, ALB, and ASG modules.

## What Each Module Does

| Module | Responsibility |
|---|---|
| `modules/ec2` | Launch Template, instance security group, IMDSv2, user data, instance and volume tags. |
| `modules/alb` | ALB security group, ALB, target group, HTTP listener, and request-count alarm. |
| `modules/asg` | Auto Scaling Group, scale-in/out policies, CPU alarms, ASG metrics, and CloudWatch dashboard. |

## Best-Practice Notes

- The EC2 security group only allows HTTP from the ALB security group, not from the whole internet.
- `create_before_destroy` protects replacement workflows for the Launch Template and ASG.
- `force_delete` is enabled only outside production so dev cleanup does not hang on ASG termination.
- Tags are merged consistently with `Environment`, `ManagedBy`, `Project`, `Owner`, and `Day`.
- The dev environment can auto-discover the default VPC/subnets for the lab, while still allowing explicit VPC/subnet inputs.
- The dev environment filters discovered subnets to AZs that support the selected EC2 instance type, avoiding the Day 16 class of "instance type not supported in this AZ" failures.
- In production, ASG instances should use private subnets with outbound NAT access. The default VPC path is only for this short-lived dev lab.

## Run Order

### 1. Bootstrap Remote State

The bootstrap step creates the S3 state bucket and DynamoDB lock table before
the dev environment tries to use them. S3 bucket names are globally unique, so
if AWS returns a region mismatch for an old bucket name, choose a fresh bucket
name and keep `bootstrap/variables.tf`, `backend.tf`, and `envs/dev/backend.tf`
in sync.

```bash
terraform -chdir=day_26/day26-scalable-web-app/bootstrap init
terraform -chdir=day_26/day26-scalable-web-app/bootstrap validate
terraform -chdir=day_26/day26-scalable-web-app/bootstrap plan -out=bootstrap.tfplan
terraform -chdir=day_26/day26-scalable-web-app/bootstrap apply bootstrap.tfplan
```

Expected result: S3 state bucket and DynamoDB lock table are created.

### 2. Initialize and Review Dev Plan

```bash
terraform -chdir=day_26/day26-scalable-web-app/envs/dev init -reconfigure
terraform -chdir=day_26/day26-scalable-web-app/envs/dev validate
terraform -chdir=day_26/day26-scalable-web-app/envs/dev plan -out=day26.tfplan
```

`-reconfigure` tells Terraform to ignore any previously cached backend
settings in `.terraform/` and initialize this directory using the current
`backend.tf` values.

Review the plan before apply. Any destroy action should stop the workflow for review.

### 3. Apply the Saved Plan

```bash
terraform -chdir=day_26/day26-scalable-web-app/envs/dev apply day26.tfplan
```

### 4. Verify the Application

```bash
terraform -chdir=day_26/day26-scalable-web-app/envs/dev output
curl -s "$(terraform -chdir=day_26/day26-scalable-web-app/envs/dev output -raw alb_url)"
```

Expected page text:

```text
Deployed with Terraform - Day 26
```

Also verify in the AWS Console:

- EC2 -> Auto Scaling Groups: desired instances are healthy.
- EC2 -> Target Groups: targets are healthy.
- CloudWatch -> Alarms: CPU high/low alarms exist.
- CloudWatch -> Dashboards: the Day 26 dashboard exists.

CLI target health check:

```bash
aws elbv2 describe-target-health \
  --target-group-arn "$(terraform -chdir=day_26/day26-scalable-web-app/envs/dev output -raw target_group_arn)" \
  --query "TargetHealthDescriptions[*].[Target.Id,TargetHealth.State]" \
  --output table
```

### 5. Confirm Clean State

```bash
terraform -chdir=day_26/day26-scalable-web-app/envs/dev plan
```

Expected:

```text
No changes. Your infrastructure matches the configuration.
```

### 6. Destroy Dev Resources

```bash
terraform -chdir=day_26/day26-scalable-web-app/envs/dev destroy
```

Post-destroy checks:

```bash
aws autoscaling describe-auto-scaling-groups \
  --query "AutoScalingGroups[?contains(AutoScalingGroupName, 'day26-web')].AutoScalingGroupName"

aws elbv2 describe-load-balancers \
  --query "LoadBalancers[?contains(LoadBalancerName, 'day26-web')].LoadBalancerArn"
```

Expected:

```text
[]
[]
```

### 7. Destroy Bootstrap Backend Last

Only do this after the dev environment is fully destroyed.

```bash
terraform -chdir=day_26/day26-scalable-web-app/bootstrap plan -destroy -out=bootstrap-destroy.tfplan
terraform -chdir=day_26/day26-scalable-web-app/bootstrap apply bootstrap-destroy.tfplan
```

The bootstrap bucket uses `force_destroy = true` for this lab so versioned state objects do not block cleanup. In production, keep state buckets protected and retained.

## Day 26 Outcome

This lab creates a complete scalable web tier:

- ALB for traffic entry.
- Launch Template for repeatable instance configuration.
- ASG for self-healing and capacity management.
- CloudWatch alarms connected to scaling policies.
- Dashboard and request alarm for operational visibility.
- Remote backend and locking for safer Terraform collaboration.
