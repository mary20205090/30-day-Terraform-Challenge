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

## Goal

The goal of Day 8 is to stop copying the same infrastructure logic across
environments and instead package that logic into a reusable module with:

- module inputs
- module outputs
- a clear directory structure

## Module Outputs

The root module exposes these outputs from the reusable module:

- `alb_dns_name`
- `asg_name`
