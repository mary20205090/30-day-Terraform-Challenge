# Day 24: Final Exam Review and Certification Focus

Day 24 is focused exam preparation. No new infrastructure is deployed today. The goal is to close the gap between "I understand Terraform" and "I can answer Terraform Associate questions accurately under time pressure."

Official references:
- Study guide: https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-study-004
- Sample questions: https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-questions-004
- Review tutorial: https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004

## Day 24 Goals

- Drill yellow and red topics from the Day 23 self-audit.
- Simulate real exam timing: 57 questions in 60 minutes.
- Review the four highest-weight domains.
- Memorize common CLI and state-management traps.
- Build a practical exam-day strategy.
- Answer flashcard-style questions without notes.

## Focused Weak-Area Review

Based on the Day 23 audit, these are the areas to drill first.

| Topic | Current Confidence | Drill Method | Target Time |
|---|---|---|---|
| Terraform state commands | Yellow | Practice `state list`, `state show`, `state rm`, `state mv` on safe examples | 45 min |
| `terraform import` behavior | Yellow | Review import flow and remember it does not generate `.tf` configuration | 30 min |
| HCP Terraform workspaces | Yellow | Compare CLI workspaces vs HCP Terraform workspaces | 30 min |
| Provider aliases | Yellow | Re-read syntax and explain multi-region provider selection | 30 min |
| Non-cloud providers | Yellow | Review `random`, `local`, and `tls` provider use cases | 30 min |
| CLI flags and traps | Yellow | Write one scenario per important command flag | 45 min |
| Sensitive data behavior | Yellow | Remember `sensitive = true` masks output but does not remove values from state | 20 min |

## Full Exam Simulation

Rules:
- Set a 60-minute timer.
- Answer 57 questions.
- Do not pause.
- Do not look anything up.
- Do not skip.
- Flag uncertain questions and return to them at the end.

Scorecard:

| Item | Result |
|---|---|
| Start time | Completed during Day 24 session |
| End time | Completed during Day 24 session |
| Score | 44 / 57 |
| Percentage | 77.2% |
| Passed 70% target? | Yes |
| Questions flagged | Not separately recorded |
| Topics missed | See missed or uncertain topics below |
| Follow-up study needed | State, provider aliases, lock file, HCP Terraform, sensitive state values |

Simulation result:

| Item | Result |
|---|---|
| Total questions | 57 |
| Correct answers | 44 |
| Wrong answers | 13 |
| Score percentage | 77.2% |
| Passed 70% target? | Yes |

The result is above the 70% passing target, with clear weak areas to review before the exam.

Missed or uncertain topics:
- `.terraform.lock.hcl` vs `terraform.tfstate`
- `terraform init -upgrade`
- Provider alias syntax: `provider = aws.west`
- `terraform apply -refresh-only`
- Terraform Cloud vs Terraform Enterprise
- Backend migration behavior during `terraform init`
- `random_password` and sensitive values being stored in state
- State-only commands such as `terraform state rm` and `terraform import`

Follow-up review plan:
- Re-read provider dependency locking and `terraform init -upgrade`.
- Drill `terraform state rm`, `terraform import`, and `terraform apply -refresh-only`.
- Memorize provider alias syntax.
- Compare HCP Terraform/Terraform Cloud vs Terraform Enterprise.
- Review sensitive values, generated secrets, and state security.

Practice sources:
- Official HashiCorp sample questions
- Terraform Associate review tutorial
- Day 23 original practice questions

## High-Weight Domain Drill

The four heaviest areas are where most of the exam value lives.

### Terraform CLI - 26%

Know these exact behaviors.

| Command or Flag | Exam Behavior |
|---|---|
| `terraform init -upgrade` | Upgrades provider selections within version constraints and updates the lock file. |
| `terraform plan -target=...` | Plans only selected resources and dependencies; useful for recovery, not normal workflow. |
| `terraform apply -auto-approve` | Applies without the interactive approval prompt. |
| `terraform destroy` | Equivalent to `terraform apply -destroy`. |
| `terraform state rm` | Removes a resource from state only; it does not destroy the real object. |
| `terraform import` | Adds an existing real object to state; it does not write the resource block for you. |
| `terraform workspace new` | Creates a workspace and switches to it. |
| `terraform output -json` | Prints outputs in machine-readable JSON. |

### Terraform Basics - 24%

High-confidence reminders:
- `terraform.tfstate` maps Terraform configuration to real infrastructure.
- `terraform.tfstate.backup` is a previous local copy of state.
- `.terraform.lock.hcl` records provider versions and checksums.
- `terraform refresh` is deprecated; prefer `terraform apply -refresh-only`.
- A data source reads existing information. A resource manages infrastructure lifecycle.
- Variables are inputs. Locals are internal named expressions. Outputs expose values.
- Meta-arguments include `depends_on`, `count`, `for_each`, `lifecycle`, and `provider`.

Function examples:

```hcl
locals {
  merged     = merge(var.common_tags, { Name = "example" })
  upper_names = [for name in var.names : upper(name)]
  name_map   = { for name in var.names : name => length(name) }
}
```

### IaC Concepts - 16%

| Concept | Exam Reminder |
|---|---|
| Declarative IaC | You describe the desired end state. Terraform decides the operations. |
| Imperative IaC | You describe step-by-step commands. |
| Idempotency | Reapplying the same config should converge to the same result. |
| Immutable infrastructure | Prefer replacement over risky in-place mutation. |
| Drift | Real infrastructure differs from state/configuration. |

### Terraform Purpose - 20%

Key points:
- Terraform is provider-agnostic. It can manage anything with a provider and API.
- Terraform uses state to map resource blocks to real infrastructure.
- The core workflow is Write -> Plan -> Apply.
- HCP Terraform is hosted SaaS. Terraform Enterprise is self-hosted.

## Exam Traps

| Trap | Correct Thinking |
|---|---|
| `terraform plan` shows no changes | Check whether state is fresh and whether the right workspace/backend is selected. |
| `terraform destroy` vs `terraform state rm` | Destroy deletes real infrastructure. State rm only forgets it. |
| Required variables | Variables with no default must be supplied or Terraform prompts/errors. |
| Module source pinning | `?ref=main` is mutable. `?ref=v1.0.0` is immutable if the tag is not moved. |
| `sensitive = true` | Masks CLI output, but values can still be stored in state. |
| Multi-select questions | If it says select TWO, choose exactly two. |

## Flashcard Answers

1. What file does `terraform init` create to record provider versions?

Answer: `.terraform.lock.hcl`.

2. What is the difference between `terraform.workspace` and an HCP Terraform workspace?

Answer: `terraform.workspace` is the selected CLI workspace name available inside configuration. An HCP Terraform workspace is a remote execution, state, variables, and collaboration container.

3. If you run `terraform state rm aws_instance.web`, what happens to the EC2 instance in AWS?

Answer: Nothing happens to the real EC2 instance. Terraform only removes the state mapping.

4. What does `depends_on` do and when should you use it?

Answer: It creates an explicit dependency when Terraform cannot infer one from references. Use it sparingly for hidden dependencies.

5. What is the purpose of `.terraform.lock.hcl`?

Answer: It locks provider selections and checksums so future installs are reproducible.

6. How does `for_each` differ from `count` when items are removed from the middle of a collection?

Answer: `for_each` uses stable keys, so unaffected items keep their identity. `count` uses numeric indexes, so removing a middle item can shift indexes and cause unexpected changes.

7. What does `terraform apply -refresh-only` do?

Answer: It updates Terraform state to match real infrastructure without proposing normal create, update, or destroy actions.

8. What is the maximum number of items you can specify in a single `terraform import` command?

Answer: One.

9. What happens when you run `terraform plan` against a workspace that has never been applied?

Answer: Terraform plans to create all configured resources because the workspace has no existing state for them.

10. What does `prevent_destroy` do and what does it not prevent?

Answer: It blocks Terraform plans that would destroy the protected resource. It does not stop someone from deleting the resource manually outside Terraform, and it does not help if the lifecycle rule is removed first.

## Practice Questions From Today's Weak Areas

1. You run `terraform state rm aws_s3_bucket.logs`. What happens?

A. Terraform deletes the S3 bucket.
B. Terraform removes the bucket from state only.
C. Terraform imports the bucket again.
D. Terraform locks the bucket.

Correct: B. The real bucket remains.

2. What does `terraform import` do?

A. Creates a resource in AWS.
B. Writes a full `.tf` resource block.
C. Adds an existing object to Terraform state.
D. Deletes unmanaged infrastructure.

Correct: C. You still write the configuration yourself.

3. Why is `for_each` often safer than `count` for named resources?

A. It never creates resources.
B. It uses stable keys instead of list indexes.
C. It skips state.
D. It only works with modules.

Correct: B. Stable keys reduce unwanted replacement when collections change.

4. What does `sensitive = true` do?

A. Removes the value from state.
B. Encrypts the value in Terraform code.
C. Masks the value in CLI output.
D. Prevents provider access.

Correct: C. Sensitive values may still be stored in state.

5. What does `terraform init -upgrade` do?

A. Forces Terraform CLI upgrade.
B. Updates provider selections within allowed constraints.
C. Deletes the backend.
D. Applies the latest plan.

Correct: B. It can update `.terraform.lock.hcl`.

## Exam-Day Strategy

- Move quickly. 57 questions in 60 minutes means about one minute per question.
- Answer easy questions first, but do not leave blanks.
- Flag uncertain questions and return after the first pass.
- On multiple choice, eliminate obviously wrong answers first.
- On multi-select, obey the exact count.
- Watch for wording around state, real infrastructure, and saved configuration.
- Trust fundamentals: Write -> Plan -> Apply, state maps config to real objects, and `state rm` does not destroy.

## Day 24 Checklist

- [ ] Focused pass through official study guide
- [ ] Review official sample questions
- [ ] Review Terraform Associate tutorial questions
- [ ] Complete 57-question simulation in 60 minutes
- [ ] Record score and missed topics
- [ ] Re-drill yellow/red topics
- [ ] Answer flashcards without notes
- [ ] Update study plan for Day 25

## Key Takeaway

The exam rewards precise Terraform behavior. It is not enough to know that Terraform uses state; I need to know exactly what each command does to configuration, state, and real infrastructure.
