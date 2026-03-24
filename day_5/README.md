# Day 5 - Managing Load Balancers and Terraform State

Day 5 focused on two big Terraform ideas:

- scaling infrastructure with an AWS Application Load Balancer (ALB) and Auto Scaling Group (ASG)
- understanding how Terraform state tracks infrastructure and detects drift

This folder contains my Day 5 Terraform configuration and notes from the hands-on state experiments.

## What I Built

The Day 5 deployment includes:

- an internet-facing Application Load Balancer
- a listener on port `80`
- a Target Group with HTTP health checks
- a Launch Template for EC2 instances
- an Auto Scaling Group attached to the Target Group
- security groups that allow public HTTP access to the ALB while restricting direct access to the instances
- output values exposing the ALB DNS name and browser URL

Request flow:

```text
Browser -> ALB -> Target Group -> EC2 instances in ASG
```

This architecture is more resilient than a single EC2 instance because the ALB routes traffic to healthy instances and the ASG replaces instances when needed.

## Key Terraform Files

- `main.tf`
  Creates the ALB, listener, target group, launch template, Auto Scaling Group, security groups, and outputs.
- `variables.tf`
  Defines reusable input values such as region, project name, instance type, server port, and scaling settings.

## Verification

After `terraform apply`, I verified the deployment by:

1. opening the `alb_url` output in the browser
2. confirming the page loaded successfully through the load balancer
3. confirming the page displayed:
   - `day5-web-app`
   - `Environment: dev`
   - `Region: us-west-2`
   - `Served through an ALB by an Auto Scaling Group.`

Example outputs:

```bash
alb_dns_name = "day5-web-app-alb-1529043971.us-west-2.elb.amazonaws.com"
alb_url      = "http://day5-web-app-alb-1529043971.us-west-2.elb.amazonaws.com"
```

## Terraform State Observations

After deployment, I inspected the local state file and related Terraform state commands:

```bash
terraform show
terraform state list
terraform state show aws_lb.example
terraform state show aws_autoscaling_group.example
```

Things I observed:

- Terraform state stores the mapping between Terraform resources and real AWS resources
- it records resource IDs, ARNs, tags, attributes, and outputs
- the state file is what helps Terraform know what it created and what it needs to compare during `plan`

What stood out most was that the state file contains much more than just names. It is Terraform's record of how the configuration maps to real infrastructure.

## State Experiments

### Experiment 1 - Manual state tampering

I manually edited a value inside `terraform.tfstate`.

What happened:

- a normal `terraform plan` did not clearly show the change because Terraform refreshed from AWS first
- when I ran `terraform plan -refresh=false`, Terraform compared the configuration against the tampered state
- Terraform then proposed changes based on the incorrect state

Lesson:

- manual state editing is risky
- incorrect state can make Terraform propose unnecessary or dangerous changes
- state files should not be edited by hand

### Experiment 2 - Real infrastructure drift

I manually changed the `Environment` tag on the ALB in the AWS Console from:

- `dev`

to:

- `manual-change`

Then I ran `terraform plan`.

Terraform detected the drift and proposed changing the ALB tag back to `dev`.

Lesson:

- drift happens when real infrastructure changes outside Terraform
- Terraform can detect that drift and propose reconciliation

Additional note:

- changing a tag on one EC2 instance launched by the ASG did not produce a clear drift result
- changing the ALB tag worked better because the ALB is directly managed by Terraform

## Terraform Block Comparison Bonus

| Block Type | Purpose | When to Use | Example |
|------------|---------|-------------|---------|
| `provider` | Configures the cloud provider | Once per provider | `provider "aws" { region = var.region }` |
| `resource` | Creates or manages infrastructure | For resources Terraform should control | `resource "aws_lb" "example" { ... }` |
| `variable` | Declares input values | To avoid hardcoding | `variable "instance_type" { default = "t3.micro" }` |
| `output` | Exposes values after apply | For useful values like DNS names and URLs | `output "alb_dns_name" { value = aws_lb.example.dns_name }` |
| `data` | Reads existing provider information | To reference existing infrastructure | `data "aws_availability_zones" "all" {}` |
| `terraform` | Configures Terraform itself | For backends and required providers | `terraform { backend "s3" { ... } }` |

## What I Learned

Day 5 reinforced that:

- ALBs and ASGs make applications more resilient and production-like
- Terraform state is essential for tracking infrastructure
- drift detection is one of Terraform's most practical features
- remote state storage matters for collaboration
- state locking matters because multiple users should not update the same state at the same time
- state files should never be committed to Git because they can contain sensitive or fast-changing infrastructure data

## Cleanup

When finished testing:

```bash
terraform destroy
```
