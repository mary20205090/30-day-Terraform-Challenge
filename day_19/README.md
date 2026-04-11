# Day 19: Adopting Infrastructure as Code in Your Team

## Chapter 10 Notes (Adopting IaC in Your Team)

This section is about the people and process changes needed to make IaC stick.
The core message is that tooling alone is not enough. Successful adoption
requires leadership buy-in, incremental delivery, and time for the team to
learn safely.

### 1. Convince Leadership (Lead With Problems, Not Features)

Key idea:
Leaders care about opportunity cost and outcomes. A pitch should be framed
around solving a real pain point, not around Terraform features.

What the author emphasizes:
- IaC has real costs: skills gap, new tools, mindset shift, and time spent
  away from other priorities.
- A manager is weighing trade-offs. Your job is to show why IaC solves a
  top-priority problem better than the alternatives.
- The most effective pitch focuses on the biggest pain (e.g., outages caused
  by manual changes) and paints a concrete outcome (e.g., reduce outages,
  improve reliability, enable safer automation).
- IaC is not always the right fit. In some contexts (very small teams or
  short-lived projects) manual infrastructure may still be acceptable.

Practical framing:
- Identify the single most costly, visible problem.
- Show how IaC eliminates or reduces that specific problem.
- Make the case in terms of outcomes, not features.

### 2. Work Incrementally (Avoid Big-Bang Migrations)

Key idea:
Large migrations frequently fail. Incremental adoption is the only reliable
path.

What the author emphasizes:
- “False incrementalism” is when intermediate steps deliver no value until
  the very end. That is risky and often fails.
- Each step should produce its own value, even if later steps never happen.
- Focus on one small, concrete problem or one team at a time.
- A quick win builds momentum and creates internal advocates.

Practical framing:
- Pick one high-impact pain point and solve it with IaC.
- Ship value early, then expand in small, repeatable steps.

### 3. Give Your Team Time to Learn (Avoid the Drift Trap)

Key idea:
If the team is not trained and supported, IaC will be abandoned when
pressure hits.

What the author emphasizes:
- IaC adoption fails when only one person knows how it works.
- In an outage, teammates will use the fastest method they know.
  If that is manual fixes, the infrastructure drifts and Terraform becomes
  untrusted and unused.
- Without time and learning support, the organization quickly reverts
  to manual changes.

Practical framing:
- Allocate time for training and practice.
- Provide documentation, examples, and safe learning environments.
- Make the “right” approach the easiest approach during incidents.

### 4. Cultural Shift (Code-First Operations)

Key idea:
Moving to IaC changes how teams think about infrastructure.

What the author emphasizes:
- Teams must accept indirect changes through code review and automation,
  not direct manual edits.
- This shift feels slower at first but enables reliability and repeatability.
- Process and culture change are as important as the code.

## Summary: The Adoption Strategy in One Page

1. Start with a real, painful problem.
2. Solve it with a small, IaC-driven win.
3. Use that win to build trust and momentum.
4. Scale slowly, one concrete win at a time.
5. Invest in training and create youasla safe learning path.
6. Reinforce a culture where infrastructure changes happen through code.

---

## Day 19 Reflection (Current State Assessment)

### Current state
- Provisioning approach:
  Manual console changes plus scripts. We create a branch, open a PR, merge
  in Bitbucket, then pull changes on the production server with `git pull`.
  We also use S3 for storage, and credentials are set in environment
  variables on the server. Environment changes are updated manually on the
  server and are not committed back to the repo.
- People and approvals:
  Three senior engineers. Flow is build -> PR -> QA -> merge -> pull on prod.
- Incidents:
  One outage caused by a Cloudflare incident. Another outage from exhausted
  workers; I checked app/db logs, restarted workers as a temporary fix, then
  optimized as a longer-term fix.
- Drift:
  Currently no known drift between documented and actual infra.
- Secrets:
  Stored in environment variables on servers (including S3 credentials);
  anyone with server access can read them.

### Team readiness
- Version control familiarity for infrastructure:
  Fair. We already use PR flow, but infra still changes outside code.
- Executive appetite for tooling change:
  Moderate. We already use Bitbucket PRs, so there is a path to adopt IaC if
  the pitch is tied to outcomes.
- Trust in automated deployments:
  Still learning. Trust would increase with containerized environments,
  staged rollout, and clear rollback procedures.

---

## IaC Adoption Plan (4 Phases)

Each phase is designed to finish in 2–4 weeks without stopping current work.

### Phase 1 — Start with something new
Pick one new resource to avoid migration risk.
Suggested: a new S3 bucket for logs or backups. We already use S3, but this
would be a new bucket managed entirely by Terraform to create a clear,
low‑risk IaC win.

Deliverables:
- Terraform configuration for the chosen resource
- Remote state in S3
- PR-based review in Bitbucket
- Team can run `terraform plan` and interpret output

### Phase 2 — Import existing infrastructure
Bring in high-change or incident-prone resources first.
Suggested: worker security group and any autoscaling group settings.

Example commands:
```
terraform import aws_s3_bucket.existing_logs my-existing-logs-bucket
terraform import aws_security_group.existing sg-0abc123def456789
```

### Phase 3 — Establish team practices
- Module versioning and internal registry
- PR review required for all infra changes
- `terraform plan` output required in PR
- Automated `terraform fmt` and `terraform validate` in CI
- State locking with DynamoDB
- No manual console changes for Terraform-managed resources

### Phase 4 — Automate deployments
- CI/CD triggers `terraform apply` on merge to main
- Approval gate for production
- Rollback and runbook documented

---

## Business Case for IaC (Org-Specific)

| Business Problem | IaC Solution | Measurable Outcome |
|---|---|---|
| Manual changes after PR merge (drift risk) | Terraform workflow with `plan` and review before apply | Fewer production incidents and rollback events |
| Worker exhaustion causing downtime | Codified autoscaling and health checks | Reduced outage duration and faster recovery |
| Env updates applied manually on servers | Environment config stored in Terraform and reviewed in PRs | Clear audit trail and fewer silent changes |
| S3 credentials accessible to anyone with server access | Centralized secret management and least‑privilege IAM | Reduced credential exposure and tighter access |
| Slow or inconsistent infra updates | Reusable modules plus standard CI checks | Faster, safer releases and consistent environments |
