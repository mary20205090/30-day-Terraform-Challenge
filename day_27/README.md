# Day 27: 3-Tier Multi-Region High Availability Infrastructure with AWS and Terraform

Day 27 moves from a single-region scalable app to a multi-region architecture.
The goal is to model a production-style stack with:

- a VPC per region
- an ALB per region
- an Auto Scaling Group per region
- a primary RDS instance plus a cross-region read replica
- Route53 failover DNS

## Key Design Notes

- `modules/vpc` creates region-local networking: VPC, public/private subnets, IGW, NAT, and route tables.
- `modules/alb` exposes the public entry point for each region.
- `modules/asg` owns the launch template, instance security group, scaling policies, and CPU alarms.
- `modules/rds` creates the primary Multi-AZ database and the secondary read replica.
- `modules/route53` models DNS failover from primary to secondary.
- Route53 failover is optional for this lab if you do not own a domain yet.

## Important Fixes Applied

Two practical issues from the pasted task were corrected:

1. The RDS module needs the application tier security group ID, not the ASG name.
   The ASG module now outputs `instance_security_group_id`, and that is what the
   RDS modules consume.

2. Terraform only reads files in the active root module directory.
   Because Day 27 runs from `envs/prod`, that directory includes its own
   `provider.tf` and `backend.tf` alongside the root copies.

## Suggested Run Flow

1. Update backend bucket/table names in:
   - `day_27/day27-multi-region-ha/backend.tf`
   - `day_27/day27-multi-region-ha/envs/prod/backend.tf`
2. Replace placeholders in `envs/prod/terraform.tfvars`:
   - AMI IDs
   - DB password
   - hosted zone ID and domain name only if `create_route53_failover = true`
3. Run from `envs/prod`:

```bash
terraform init -reconfigure
terraform validate
terraform plan -out=day27.tfplan
terraform apply day27.tfplan
```

If `create_route53_failover = false`, verify the lab with:

- `primary_alb_dns_name`
- `secondary_alb_dns_name`
- `application_url` (this falls back to the primary ALB URL)

## Cost and Risk Reminder

This lab is much heavier than earlier days. NAT Gateways, ALBs, EC2 instances,
RDS, and cross-region replication can become expensive quickly. Review the plan
carefully before any apply, and destroy the stack as soon as verification is
done.
