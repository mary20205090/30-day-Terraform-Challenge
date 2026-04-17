# Day 22 Reflection

## What I built

Across the challenge so far, I worked with EC2, security groups, ALBs, target
groups, listeners, Auto Scaling Groups, launch templates, CloudWatch alarms,
SNS topics, S3 backend patterns, DynamoDB state locking, reusable modules,
manual tests, Terratest, native `terraform test`, GitHub Actions, Terraform
Cloud workflow concepts, Sentinel policies, and cost gates.

## What changed in how I think

I now think about infrastructure changes as reviewed, stateful, blast-radius
controlled releases, not just `terraform apply` commands.

## What was harder than expected

State and saved plans were the hardest mental shift. The stale plan issue made
it clear that Terraform is always protecting a specific state snapshot.

## What I would do differently

From Day 1, I would standardize naming, tags, README notes, cleanup commands,
and backend strategy instead of adding those habits later.

## What comes next

After the exam, the first real project I want to apply this to is a safer
environment deployment workflow: containerized app runtime, versioned
infrastructure, reviewed plans, and secrets managed outside the server.
