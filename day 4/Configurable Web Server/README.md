# Day 4 - Configurable Web Server

This lab focused on understanding Terraform data blocks and using queried AWS information inside managed resources.

## What This Lab Covers

- Query the current AWS region with a Terraform data source
- Query the available availability zones in the active region
- Query the most recent Ubuntu 22.04 AMI from Canonical
- Use queried values inside Terraform resources
- Create supporting infrastructure for a simple EC2 deployment

## Terraform Concepts Practiced

### Resource blocks

`resource` blocks create or manage infrastructure in AWS.

Examples from this lab:

- `aws_vpc`
- `aws_subnet`
- `aws_security_group`
- `aws_instance`

### Data blocks

`data` blocks read existing information from AWS instead of creating it.

Examples from this lab:

- `data "aws_region" "current"`
- `data "aws_availability_zones" "available"`
- `data "aws_ami" "ubuntu_22_04"`

The reference pattern used in the lab is:

```hcl
data.<type>.<name>.<attribute>
```

Examples:

```hcl
data.aws_region.current.id
data.aws_availability_zones.available.names
data.aws_ami.ubuntu_22_04.id
```

## Files

- [main.tf](./main.tf): Main Terraform configuration for the lab
- [variables.tf](./variables.tf): Input variables used by the lab

## Resources Used

This lab creates or manages:

- 1 VPC
- Private subnet resources
- 1 public subnet
- 1 security group
- 1 EC2 instance

## Why Data Blocks Matter

Using data blocks makes Terraform more flexible because values do not need to be hardcoded.

Instead of manually typing values like:

- AWS region
- availability zones
- AMI IDs

Terraform can query AWS directly and use the returned values in the configuration.

## Commands Used

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Preview changes:

```bash
terraform plan
```

Apply changes:

```bash
terraform apply
```

Destroy resources after the lab:

```bash
terraform destroy
```

## Troubleshooting Notes

### Deprecated region attribute

The original lab used `data.aws_region.current.name`, but newer AWS provider versions mark `name` as deprecated. In this lab folder, `data.aws_region.current.id` is used instead.

### Subnet CIDR conflicts

Subnet CIDR blocks must not overlap within the same VPC. During this lab, subnet index values had to be adjusted so each subnet received a unique CIDR range.

### Partial apply behavior

A failed `terraform apply` can still leave some resources created in AWS. Always check both:

- `terraform state list`
- AWS Console

## AWS Console Verification

After a successful apply, check:

- `VPC > Your VPCs`
- `VPC > Subnets`
- `VPC > Security Groups`
- `EC2 > Instances`

## Key Takeaways

- `resource` creates or manages infrastructure
- `data` looks up existing information
- Data sources help avoid hardcoding values
- `terraform plan` helps review changes before applying
- `terraform destroy` is important for cleanup, especially on Free Tier

## Cleanup Reminder

After finishing the lab:

1. Run `terraform destroy`
2. Confirm `terraform state list` returns nothing
3. Verify in AWS Console that the VPC, subnets, security groups, and instances are gone

