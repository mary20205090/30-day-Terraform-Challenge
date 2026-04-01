# Day 11: Mastering Terraform Conditionals

Day 11 focuses on making one Terraform codebase behave differently across environments without duplicating files.

This folder contains:

- a reusable child module in `modules/services/webserver-cluster`
- a `dev` caller in `live/dev`
- a `production` caller in `live/production`

## What This Day Demonstrates

- ternary conditionals moved into `locals`
- optional resources created with `count = condition ? 1 : 0`
- safe outputs for conditionally created resources
- validation on the `environment` variable
- conditional data lookups for existing versus newly created VPCs

## Environment-Aware Decisions

The module uses the `environment` variable to drive:

- instance type
- min and max cluster size values
- detailed monitoring defaults
- DNS record creation defaults
- whether SSH access is opened for non-production environments

## Optional Resources

The module creates extra resources only when needed:

- CloudWatch alarm when monitoring is enabled
- Route53 record when DNS creation is enabled
- a new VPC and subnet only when `use_existing_vpc = false`
