# Day 21 Sentinel Notes

Sentinel is Terraform Cloud's policy-as-code framework. It evaluates a
Terraform plan before apply is allowed.

## Policy Added

`require-instance-type.sentinel` allows only approved EC2 instance sizes:

- `t2.micro`
- `t2.small`
- `t2.medium`
- `t3.micro`
- `t3.small`

## What Sentinel Enforces

Sentinel enforces organization-level policy against the generated plan.

This policy answers:

- Are planned EC2 instance types allowed?
- Should this plan be blocked before apply?

## How Sentinel Differs From `terraform validate`

`terraform validate` checks whether the Terraform configuration is syntactically
valid and internally consistent.

Sentinel checks whether a valid plan is allowed by company policy.

Example:
- `terraform validate` may accept `m5.24xlarge`.
- Sentinel can reject it because it is not approved for this sandbox workflow.

## Production Review Note

Human production review is best enforced with Terraform Cloud apply approvals.
Sentinel can enforce policy rules, while mandatory apply approval provides the
human review gate before production changes are applied.
