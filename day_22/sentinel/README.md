# Day 22 Sentinel Policies

These policies are examples for Terraform Cloud/Enterprise policy sets.

## require-instance-type.sentinel

Allows only small sandbox instance types: `t2.micro`, `t2.small`, `t2.medium`,
`t3.micro`, and `t3.small`.

## require-terraform-tag.sentinel

Requires taggable AWS resources to include `ManagedBy = "terraform"`.

## cost-check.sentinel

Blocks an apply if Terraform Cloud cost estimation shows a monthly increase of
`$50` or more.

## Sentinel vs terraform validate

`terraform validate` checks whether the configuration is syntactically and
structurally valid Terraform. Sentinel checks whether a valid plan is allowed by
the team's rules.
