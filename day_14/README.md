# Day 14: Working with Multiple Providers - Part 1

Day 14 focuses on how Terraform providers work, how Terraform installs and pins them, and how provider aliases make multi-region and multi-account deployments possible.

## What I Built

This folder contains a practical multi-region AWS example:

- a default AWS provider for `us-east-1`
- an aliased AWS provider for `us-west-2`
- a primary S3 bucket in the default region
- a replica S3 bucket in the aliased region
- IAM resources for S3 replication
- an S3 replication rule between the two regions

It also includes a separate example file for the multi-account `assume_role` pattern:

- `multi_account_example.tf.example`

## Provider Notes from Chapter 7

### What is a provider?

A provider is a plugin that Terraform Core uses to translate Terraform configuration into API calls for a real platform such as AWS.

- Terraform Core handles:
  - `plan`
  - `apply`
  - parsing HCL
  - dependency graphs
  - state management
- Providers handle:
  - the actual API calls to AWS, Azure, GCP, and other platforms

### How Terraform installs providers

When you run `terraform init`, Terraform downloads the provider plugins listed in `required_providers`.

This folder uses:

```hcl
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
```

Best practice:

- always declare `required_providers`
- always pin a safe provider version range
- commit `.terraform.lock.hcl`

### What `.terraform.lock.hcl` does

After `terraform init`, Terraform creates `.terraform.lock.hcl`.

This file records:

- the provider source address
- the exact version Terraform selected
- the version constraints from your config
- package hashes used to verify the downloaded provider binaries

Why that matters:

- teammates use the same provider versions
- CI installs the same provider versions
- upgrades happen intentionally, not by surprise

### How you use a provider

There are two separate ideas:

1. `required_providers`
   - tells Terraform what to install
2. `provider`
   - tells Terraform how to configure it

Example:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

### Provider aliases

Aliases let you configure multiple copies of the same provider.

This folder uses:

```hcl
provider "aws" {
  region = var.primary_region
}

provider "aws" {
  alias  = "us_west"
  region = var.secondary_region
}
```

Then specific resources choose the aliased provider explicitly:

```hcl
resource "aws_s3_bucket" "replica" {
  provider = aws.us_west
  bucket   = "..."
}
```

## Multi-Region Lab Workflow

1. Initialize the folder:

```bash
cd day_14
terraform init
```

2. Inspect the provider lock file:

```bash
cat .terraform.lock.hcl
```

3. Preview the multi-region deployment:

```bash
terraform plan
```

4. If you want to deploy it:

```bash
terraform apply
```

5. When finished, destroy everything:

```bash
terraform destroy
```

## Multi-Account Pattern

If you have access to multiple AWS accounts, the pattern is to define multiple aliased providers with `assume_role`.

This repo includes that pattern in:

- `multi_account_example.tf.example`

That file is intentionally an example so it does not break the runnable multi-region lab when the role ARNs do not exist.

## AWS Provider Version Notes

From the AWS provider registry and upgrade guidance, major version bumps typically happen when there are breaking changes such as:

- deprecated arguments or resources being removed
- default behavior changes
- minimum supported Terraform version changes
- service-specific breaking schema changes

That is exactly why version pinning matters.

## My Takeaway

The biggest lesson from Day 14 is that providers are not just a small setup detail.

They control:

- where infrastructure is deployed
- which account it uses
- which region it uses
- which provider version gets installed
- how multi-region and multi-account designs are expressed in Terraform

This also made `.terraform.lock.hcl` make much more sense to me. It is not clutter. It is one of the things that keeps Terraform behavior consistent across machines.
