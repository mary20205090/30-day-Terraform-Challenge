# Day 8: Building Reusable Infrastructure with Terraform Modules

This folder is the Day 8 root module that consumes a reusable
`webserver-cluster` Terraform module.

## Structure

- `main.tf`
  - Configures the AWS provider and calls the reusable module
- `variables.tf`
  - Defines the inputs passed into the reusable module
- `modules/services/webserver-cluster`
  - Contains the reusable module implementation
- `live/dev/services/webserver-cluster`
  - Example root configuration that consumes the module for development
- `live/production/services/webserver-cluster`
  - Example root configuration that consumes the same module with different inputs

## Goal

The goal of Day 8 is to stop copying the same infrastructure logic across
environments and instead package that logic into a reusable module with:

- module inputs
- module outputs
- a clear directory structure

This module is a refactor of the repeated clustered web server code built in
earlier days. Instead of copying ALB, ASG, launch template, and security
group logic into each environment, the shared infrastructure now lives in one
module and the environment-specific values are passed in as inputs.

## Refactor Decisions

The values exposed as inputs are the ones that are expected to vary per
environment, such as:

- `cluster_name`
- `environment`
- `instance_type`
- `min_size`
- `max_size`
- `desired_capacity`
- `server_port`

Values that do not usually need to change for each caller, such as the ALB
listener behavior and some repeated networking constants, stay internal to
the module and are defined with locals.

## Module Outputs

The root module exposes these outputs from the reusable module:

- `alb_dns_name`
- `asg_name`

The reusable module itself also exposes useful values such as:

- `alb_security_group_id`
- `instance_security_group_id`
- `target_group_arn`
- `server_port`
