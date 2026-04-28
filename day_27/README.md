# Day 27: 3-Tier Multi-Region High Availability Infrastructure with AWS and Terraform

Day 27 moved from a single-region scalable app to a multi-region architecture.
The goal was to model a production-style stack with:

- a VPC per region
- an ALB per region
- an Auto Scaling Group per region
- a primary RDS instance plus a cross-region read replica
- Route53 failover DNS

The final lab was deployed, verified through the regional ALB endpoints, and
fully destroyed after testing to avoid lingering costs.

## Key Design Notes

- `modules/vpc` creates region-local networking: VPC, public/private subnets, IGW, NAT, and route tables.
- `modules/alb` exposes the public entry point for each region.
- `modules/asg` owns the launch template, instance security group, scaling policies, and CPU alarms.
- `modules/rds` creates the primary Multi-AZ database and the secondary read replica.
- `modules/route53` models DNS failover from primary to secondary.
- Route53 failover is optional for this lab if you do not own a domain yet.
- A separate `bootstrap` stack creates the remote backend bucket and lock table before `envs/prod` uses them.

## Important Fixes Applied

Several practical issues from the pasted task were corrected:

1. The RDS module needs the application tier security group ID, not the ASG
   name. The ASG module now outputs `instance_security_group_id`, and that is
   what the RDS modules consume.

2. Terraform only reads files in the active root module directory. Because Day
   27 runs from `envs/prod`, that directory includes its own `provider.tf` and
   `backend.tf` alongside the root copies.

3. Each child module now declares `required_providers` so aliased AWS providers
   can be passed into modules cleanly.

4. ALB and target group names were shortened to stay within AWS naming limits.

5. The primary RDS backup retention period was reduced for the lab so the DB
   instance could be created on the account plan in use.

6. The cross-region encrypted read replica was updated to resolve a valid KMS
   key in the destination region, which allowed the replica to be created from
   an encrypted source database.

## Run Flow Used

1. Create the backend first:

```bash
terraform -chdir=day_27/day27-multi-region-ha/bootstrap init
terraform -chdir=day_27/day27-multi-region-ha/bootstrap validate
terraform -chdir=day_27/day27-multi-region-ha/bootstrap plan -out=bootstrap.tfplan
terraform -chdir=day_27/day27-multi-region-ha/bootstrap apply bootstrap.tfplan
```

2. Then run the multi-region stack:

```bash
terraform -chdir=day_27/day27-multi-region-ha/envs/prod init -reconfigure
terraform -chdir=day_27/day27-multi-region-ha/envs/prod validate
terraform -chdir=day_27/day27-multi-region-ha/envs/prod plan -out=day27.tfplan
terraform -chdir=day_27/day27-multi-region-ha/envs/prod apply day27.tfplan
```

3. With `create_route53_failover = false`, verify the lab with:

- `primary_alb_dns_name`
- `secondary_alb_dns_name`
- `application_url` (this falls back to the primary ALB URL)

4. Destroy in reverse order:

```bash
terraform -chdir=day_27/day27-multi-region-ha/envs/prod destroy
terraform -chdir=day_27/day27-multi-region-ha/bootstrap init
terraform -chdir=day_27/day27-multi-region-ha/bootstrap plan -destroy -out=bootstrap-destroy.tfplan
terraform -chdir=day_27/day27-multi-region-ha/bootstrap apply bootstrap-destroy.tfplan
```

## Verification Summary

- Primary ALB served the application successfully and showed the deployed
  region, AZ, and environment.
- The secondary regional stack was also created successfully.
- The cross-region RDS replica was created after the encryption/KMS fix.
- Route53 remained disabled for the lab because there was no hosted zone/domain
  available in the account.
- All Day 27 AWS resources and the backend bootstrap resources were later
  verified as destroyed.

## Cost and Risk Reminder

This lab is much heavier than earlier days. NAT Gateways, ALBs, EC2 instances,
RDS, and cross-region replication can become expensive quickly. The safest lab
habit is still the same: review the plan carefully, verify quickly, and destroy
everything as soon as the architecture has been confirmed.
