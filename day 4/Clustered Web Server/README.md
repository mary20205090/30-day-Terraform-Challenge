# Day 4 - Clustered Web Server

This lab extends the single configurable web server into a clustered architecture using an Application Load Balancer and an Auto Scaling Group.

## Outcome

This lab was successfully deployed, tested through the ALB DNS name, and then destroyed after verification.

The clustered deployment worked as expected: traffic reached the Application Load Balancer, which forwarded requests to EC2 instances managed by the Auto Scaling Group.

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

## Architecture Summary

This deployment used the following request flow:

```text
Browser -> Application Load Balancer -> Target Group -> EC2 instances in Auto Scaling Group
```

Each component had a distinct role:

- the ALB received public traffic
- the listener forwarded traffic to the target group
- the target group tracked healthy EC2 instances
- the launch template defined how instances should be created
- the Auto Scaling Group maintained the desired number of instances

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

In this lab, the browser test succeeded and the page showed:

- cluster name
- environment
- region
- confirmation that traffic was being served by an Auto Scaling Group behind an ALB

## Key Takeaways

- a single-server deployment is simpler but less resilient
- an ALB provides one public entry point for multiple application instances
- an Auto Scaling Group manages instance count and replacement
- a launch template acts as the blueprint for ASG instances
- availability zones can be queried dynamically with a Terraform data source
- clustered infrastructure is closer to real production architecture than a single VM

## Cleanup Reminder

Because the ALB and Auto Scaling Group can cost more than the single-instance lab, this environment should be destroyed as soon as verification is complete:

```bash
terraform destroy
```
