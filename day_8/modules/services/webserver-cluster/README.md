# Webserver Cluster Module

This reusable Terraform module creates a simple web server cluster made of:

- an Application Load Balancer
- a target group
- a listener
- instance and ALB security groups
- a launch template
- an Auto Scaling Group

It is a refactor of the clustered infrastructure patterns used earlier in the
challenge, especially the repeated ALB, security group, launch template, and
Auto Scaling Group code from Days 4 and 5.

## Inputs

The module is configured through input variables defined in `variables.tf`.
Important inputs include:

- `cluster_name`
- `environment`
- `instance_type`
- `min_size`
- `max_size`
- `desired_capacity`
- `server_port`

These inputs are the parts of the design that are likely to change per
environment. Internal constants such as the HTTP listener port and generic
network defaults are kept inside the module with locals so consumers do not
have to manage every low-level detail.

## Outputs

The module exposes:

- `alb_dns_name`
- `asg_name`
- `alb_security_group_id`
- `instance_security_group_id`
- `target_group_arn`
- `server_port`

These outputs are meant to be consumed by the root module or by other
Terraform configurations.
