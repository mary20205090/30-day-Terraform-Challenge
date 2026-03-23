# Day 4 - Clustered Web Server

This lab extends the single configurable web server into a clustered architecture using an Application Load Balancer and an Auto Scaling Group.

## What This Lab Covers

- Use input variables to configure a clustered deployment
- Query availability zones dynamically with `data "aws_availability_zones" "all" {}`
- Create an Application Load Balancer
- Create a target group and listener
- Launch EC2 instances from a launch template
- Manage multiple instances with an Auto Scaling Group

## Core Resources

- `aws_lb`
- `aws_lb_target_group`
- `aws_lb_listener`
- `aws_launch_template`
- `aws_autoscaling_group`
- `aws_security_group`

## Data Sources Used

- `data "aws_vpc" "default"`
- `data "aws_subnets" "default"`
- `data "aws_availability_zones" "all"`
- `data "aws_ami" "ubuntu"`

## Outputs

- `alb_dns_name`
- `alb_url`

## Commands

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

## Verification

After `terraform apply`, open the ALB DNS name shown in the outputs and confirm the page loads through the load balancer.
