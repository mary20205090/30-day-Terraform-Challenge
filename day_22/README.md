# Day 22: Putting It All Together

Reference: Chapter 10 of *Terraform: Up & Running* by Yevgeniy Brikman,
sections **"Putting It All Together"** and **"Conclusion"**.

Day 22 closes the book by connecting everything from the previous chapters into
one complete team workflow: version control, testing, review, immutable
artifacts, CI/CD, policy, approval gates, deployment, verification, and cleanup.

## What The Final Notes Cover

Chapter 10 ends by comparing the application-code workflow and the
infrastructure-code workflow side by side. The lesson is not that Terraform
works exactly like application code. The lesson is that Terraform should borrow
the same engineering discipline, then add extra safeguards for state and cloud
blast radius.

## 1. One Shared Workflow Shape

Both application code and infrastructure code move through a similar path:

1. Use version control
2. Run locally or in a sandbox
3. Make code changes
4. Submit changes for review
5. Run automated tests
6. Merge and release
7. Deploy

This is the big idea that Days 20 and 21 practiced:
- Day 20 mapped application deployment to Terraform.
- Day 21 showed where infrastructure needs stronger controls.
- Day 22 combines both into one coherent pipeline.

## 2. Application Code vs Infrastructure Code

Application code usually has one repository per app, runs on localhost, and can
be deployed through many release strategies such as rolling, blue/green, or
canary deployments.

Infrastructure code is different:
- it often has separate `modules` and `live` repositories
- it should be tested in a sandbox environment, not directly on a laptop
- it depends on Terraform state
- a plan must be reviewed before apply
- deploy strategies are more limited
- failed applies need careful recovery, including state handling

Practical Day 22 lesson:
- application review asks, "Does this code behave correctly?"
- infrastructure review asks, "What real resources will this change?"

## 3. Immutable Artifacts

The chapter stresses promoting immutable, versioned artifacts across
environments.

For application code, the immutable artifact might be:
- a Docker image
- a package
- a compiled binary

For Terraform, the immutable artifact can be:
- a Git commit
- a Git tag
- a versioned module release

This is why Day 20 used `v1.3.0` and Day 21 used `v1.4.0`. Tags make the
release traceable and repeatable.

## 4. Promotion Across Environments

The same artifact should move through environments:

```text
dev -> staging -> production
```

Do not rebuild or rewrite the infrastructure code separately for each
environment. Promote the same version and change only environment inputs.

This reduces drift because dev, staging, and production are using the same
tested code version.

## 5. CI/CD Pipeline

The final workflow expects CI/CD to run the safety checks automatically.

For application code, CI/CD may run:
- unit tests
- integration tests
- linting
- packaging

For Terraform, CI/CD should run:
- `terraform fmt`
- `terraform validate`
- `terraform test`
- static analysis
- `terraform plan`
- policy checks

The plan is especially important because it shows what Terraform will do in the
cloud.

## 6. Approval Before Apply

The final workflow does not treat merge as the only approval step. For
infrastructure, there should be one more checkpoint after merge:

- review the final plan output
- confirm the blast radius
- confirm the rollback path
- then apply from a trusted environment

This connects directly to the Day 21 lesson: apply is the moment Terraform
changes real infrastructure, so it deserves stronger controls than a normal app
deploy.

## 7. Trusted Deployment Environment

The author emphasizes that infrastructure deploys should run from a controlled
environment, not from random laptops.

Good options include:
- Terraform Cloud
- Terraform Enterprise
- Atlantis
- Terragrunt pipelines
- a locked-down CI/CD worker

The deployment worker should use tightly scoped or temporary credentials where
possible. The goal is to avoid long-lived admin credentials on developer
machines.

## 8. Policy As Code

Sentinel and similar policy tools turn organization rules into enforceable code.

Examples:
- block unapproved instance types
- require tags
- prevent public storage buckets
- require approval before production apply
- prevent destructive changes unless explicitly allowed

This is different from `terraform validate`.

`terraform validate` checks whether the configuration is valid Terraform.
Policy checks decide whether a valid plan is allowed by the team.

## 9. Error Handling And State

Terraform deploys are not automatically rolled back like many application
deploys. If an apply fails halfway, some resources may already exist.

That means teams must understand:
- state locking
- state backups
- stale plans
- errored state files
- manual cleanup
- rollback plans

Day 21's stale-plan issue was a useful real example. Terraform refused to apply
an old plan because the state snapshot had changed. That was a safety feature.

## 10. Book Conclusion

The author closes by showing that Terraform lets teams manage operational
concerns using software engineering practices:

- modules
- version control
- code review
- automated tests
- CI/CD
- policy
- reusable patterns

The goal is not exciting deploys. The goal is boring, repeatable, safe deploys.
In operations, boring is good.

## Day 22 Reflection

After three weeks, the biggest shift is no longer just knowing Terraform
commands. The bigger shift is thinking like an infrastructure engineer:

- plan before apply
- review blast radius
- test before merge
- tag releases
- protect state
- clean up resources
- build workflows a team can trust

Day 22 is the bridge from learning Terraform syntax to designing Terraform
delivery systems.

## Carry Forward

The practices from Days 16-21 should continue into the rest of the challenge:

- production-grade modules and validation
- manual test checklists
- automated tests
- PR-based workflow
- saved plan review
- blast-radius documentation
- rollback planning
- Sentinel/policy thinking
- cleanup verification

This finishes the book, but it does not finish the learning. The next step is
turning these patterns into habits.
