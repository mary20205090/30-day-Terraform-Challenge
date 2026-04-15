# Day 21: Workflow for Deploying Infrastructure Code

Reference: Chapter 10 of *Terraform: Up & Running* by Yevgeniy Brikman,
section **"A Workflow for Deploying Infrastructure Code"**.

Day 21 continues yesterday's seven-step workflow, but shifts the focus from
application deployment to infrastructure deployment. The steps look familiar,
but the risks are higher because Terraform changes real cloud resources and
state.

Working lab folder for today:
- `day_21/`

Why a separate `day_21` folder:
- each day keeps its own resources and state, which avoids accidental changes
  to older labs
- the Day 21 code can reuse proven module patterns from earlier days while
  still being a standalone sandbox
- the workflow can be tested end-to-end without touching Day 20 or older
  environments

## Core Lesson

Application code and infrastructure code can use the same release shape:

1. Version control
2. Run locally
3. Make changes
4. Submit for review
5. Run automated tests
6. Merge and release
7. Deploy

The difference is the blast radius. A bad app deploy may return a 500 error.
A bad infrastructure deploy may destroy a database, break networking, remove a
load balancer, or corrupt state. That means infrastructure workflows need extra
guardrails.

## 1. Use Version Control

Application code usually uses one repo per app and branches freely.

Infrastructure code needs more discipline:

- Use a modules repo for reusable Terraform modules.
- Use a live repo for deployed environments.
- Keep the live repo as a readable map of what is deployed.
- Apply shared environments from `main` only.

Key idea from the author:

> The main branch of the live repository should be a 1:1 representation of what
> is actually deployed in production.

Practical meaning:
- Branches are fine for PR review.
- Shared environments should be applied only after merge.
- Do not apply stale feature branches to staging or production.

## 2. The Trouble With Branches

Terraform state locking prevents two applies from writing state at the same
time, but it does not protect you from applying old code from another branch.

Example risk:
- Engineer A changes instance size.
- Engineer B adds a tag from an older branch.
- Engineer B's apply may accidentally revert Engineer A's instance-size change.

This is different from app code because infrastructure maps to one real-world
environment.

Day 21 rule:
- Use branches for review.
- Merge first.
- Apply from `main`.

## 3. Run The Code Locally

Application code can run on localhost.

Terraform usually cannot. You cannot deploy an AWS ASG on a laptop. Local
Terraform testing means using a sandbox AWS account or dev environment.

For today's `day_21` lab:

```bash
terraform -chdir=day_21/live/dev workspace new dev
terraform -chdir=day_21/live/dev validate
terraform -chdir=day_21/live/dev plan -out=day21.tfplan
```

Only apply after reviewing the plan.

## 4. Make Code Changes

Terraform feedback loops are slower than app feedback loops because they may
create or replace real cloud resources.

Day 21 infrastructure change:
- add a CloudWatch alarm that watches ASG in-service capacity
- expose the alarm name as an output
- keep the change low-risk because it adds observability without changing
  traffic routing, security groups, or instance capacity

Every change must be checked with `terraform plan` before apply.

## 5. Submit Changes For Review

Infrastructure review must include:

- code diff
- `terraform plan` output
- expected resource creates, updates, and destroys
- blast-radius review

Important review questions:
- Are there unexpected destroys?
- Is this the correct environment?
- Does the plan match the intended change?
- Was it tested in dev or another sandbox first?
- Is state still aligned with reality?

## 6. Run Automated Tests

Infrastructure CI should run:

- `terraform fmt`
- `terraform validate`
- `terraform test`
- Terratest where needed
- static analysis
- `terraform plan`

Most important rule:

```text
Always run plan before apply.
```

This connects directly to Day 18 and Day 20:
- Day 18 introduced automated Terraform tests.
- Day 20 added PR-based workflow.
- Day 21 adds infrastructure-specific plan review and approval discipline.

## 7. Merge And Release

For application code, the release artifact might be a Docker image.

For Terraform, the Git repo at a tag can be the immutable release artifact.

Existing release tag check:
- `v1.3.0` already exists from the previous app workflow release

Day 21 release tag to use after merge:

```bash
git tag -a "v1.4.0" -m "Promote Day 21 infrastructure workflow"
git push origin v1.4.0
```

The same artifact should be promoted across environments:
- dev
- staging
- production

## 8. Deploy

Deploying Terraform is riskier than deploying most application code because
Terraform does not automatically roll back failed infrastructure changes.

Extra safeguards:

- apply from a trusted deployment environment
- use remote state and locking
- require approval gates
- use temporary credentials where possible
- test in pre-prod before prod
- review plan output before apply
- preserve errored state files if an apply fails

## Day 21 Implementation

Day 21 creates a standalone dev webserver cluster and adds one extra
infrastructure workflow change: an ASG capacity alarm.

Relevant files:
- `day_21/live/dev/main.tf`
- `day_21/live/dev/variables.tf`
- `day_21/live/dev/outputs.tf`
- `day_21/modules/services/webserver-cluster/webserver_cluster_test.tftest.hcl`
- `day_21/docs/infrastructure-pr-template.md`
- `day_21/sentinel/require-instance-type.sentinel`

Validated flow:

```bash
git checkout -b add-cloudwatch-alarms-day21
terraform -chdir=day_21/live/dev init
terraform -chdir=day_21/live/dev workspace new dev
terraform -chdir=day_21/live/dev validate
terraform -chdir=day_21/modules/services/webserver-cluster test
terraform -chdir=day_21/live/dev plan -out=day21.tfplan
```

Plan result:
- `16 to add`
- `0 to change`
- `0 to destroy`
- saved plan file: `day_21/live/dev/day21.tfplan`

After PR review and merge:

```bash
terraform -chdir=day_21/live/dev apply day21.tfplan
terraform -chdir=day_21/live/dev output
curl -s http://$(terraform -chdir=day_21/live/dev output -raw alb_dns_name)
```

Post-destroy verification, if the lab is destroyed:

```bash
aws ec2 describe-instances --filters "Name=tag:Project,Values=day21-infra-workflow" "Name=instance-state-name,Values=pending,running,stopping,stopped" --query "Reservations[*].Instances[*].InstanceId"
aws elbv2 describe-load-balancers --query "LoadBalancers[*].LoadBalancerArn"
```

Expected cleanup result:
- no active Day 21 test resources remain

## Day 20 vs Day 21

| Step | Day 20 Application Workflow | Day 21 Infrastructure Workflow |
|---|---|---|
| Version control | Feature branch and PR | Feature branch, but apply shared envs from `main` |
| Run locally | App-style change previewed with plan | Sandbox AWS environment required |
| Make changes | App response text update | Infra change may replace resources |
| Review | PR plus plan output | PR plus plan output plus blast-radius review |
| Tests | Unit tests via GitHub Actions | fmt, validate, test, Terratest, static analysis, plan |
| Merge/release | Merge and tag | Tagged repo/module is the deploy artifact |
| Deploy | Apply reviewed plan | Apply from trusted environment with approvals and locking |

## Main Takeaway

Infrastructure code should follow the same disciplined workflow as application
code, but with stronger safeguards around state, branches, approvals, secrets,
blast radius, and cleanup.
