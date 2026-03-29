# Webserver Cluster Module

This reusable Terraform module creates a simple web server cluster made of:

- an Application Load Balancer
- a target group
- a listener
- instance and ALB security groups
- a launch template
- an Auto Scaling Group

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

## Outputs

The module exposes:

- `alb_dns_name`
- `asg_name`

These outputs are meant to be consumed by the root module or by other
Terraform configurations.
