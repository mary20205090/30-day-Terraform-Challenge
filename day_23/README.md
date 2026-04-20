# Day 23: Exam Preparation - Brushing Up on Key Terraform Concepts

Today shifts from building infrastructure to preparing for the Terraform Associate exam.
The book is done, so the goal is to compare the hands-on work from Days 1-22 against
the official HashiCorp exam objectives.

Official references:

- Terraform Associate 004 learning path: https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-study-004
- Terraform Associate 004 exam content list: https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004
- Terraform Associate 004 sample questions: https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-questions-004

## Official Exam Focus

The current Terraform Associate 004 exam targets Terraform 1.12 concepts. The official
content list focuses on:

1. Infrastructure as Code with Terraform
2. Terraform fundamentals
3. Core Terraform workflow
4. Terraform configuration
5. Terraform modules
6. Terraform state management
7. Maintaining infrastructure with Terraform
8. HCP Terraform

The sample questions are practical. They test what commands and features actually do,
not just whether I have memorized definitions.

## Green / Yellow / Red Audit

| Objective | Rating | Honest assessment |
| --- | --- | --- |
| IaC concepts | Green | I can explain repeatability, auditability, and drift from the challenge labs. |
| Terraform purpose/fundamentals | Green | Providers, resources, variables, outputs, lock files, and state are familiar. |
| Core workflow | Green | `init`, `fmt`, `validate`, `plan`, `apply`, and `destroy` are daily muscle memory. |
| Configuration | Green/Yellow | Strong on resources, data sources, variables, locals, validation, and lifecycle. Need more function/type drills. |
| Modules | Green | Built reusable modules, examples, version tags, and registry notes. |
| State management | Yellow | Understand state, but need more drills with `state mv`, `state rm`, `import`, and drift scenarios. |
| Maintain infrastructure | Yellow | Need focused review on import, moved/removed blocks, troubleshooting, and drift. |
| HCP Terraform | Yellow/Red | Understand concepts, but need more study on remote runs, variable sets, policies, and workspaces. |
| Provider aliases | Yellow | Used before, but syntax needs quick recall practice. |
| Non-cloud providers | Yellow | Used `random`; need to review `local`, `tls`, and similar providers. |

## CLI Commands To Know Cold

| Command | What it does | Exam note |
| --- | --- | --- |
| `terraform init` | Initializes backend and downloads providers/modules | Required before most workflows. |
| `terraform fmt` | Formats Terraform code | Does not validate real infrastructure. |
| `terraform validate` | Checks config syntax and consistency | Does not prove cloud resources are healthy. |
| `terraform plan` | Shows proposed create/change/destroy actions | Refreshes state by default. |
| `terraform apply` | Applies changes and updates state | Can apply saved plan files. |
| `terraform destroy` | Destroys Terraform-managed resources | Equivalent to a destroy plan/apply. |
| `terraform output` | Reads output values from state | Useful after apply. |
| `terraform state list` | Lists resources tracked in state | Inspection only. |
| `terraform state show` | Shows details for one state address | Inspection only. |
| `terraform state mv` | Moves addresses in state | Does not move real infrastructure. |
| `terraform state rm` | Removes resource from state only | Leaves the real resource untouched. |
| `terraform import` | Adds existing infrastructure to state | Does not generate complete config by itself. |
| `terraform workspace` | Manages CLI workspaces | Different from HCP Terraform workspaces. |
| `terraform providers` | Shows providers used by config | Helps inspect dependencies. |
| `terraform login` | Authenticates to HCP Terraform | Used for cloud/remote workflows. |
| `terraform graph` | Outputs dependency graph | Useful for dependency visualization. |

Important exam reminders:

- `terraform state rm` changes state only. It does not delete the real resource.
- `terraform validate` is not a health check.
- `terraform plan` detects drift when state and real infrastructure no longer match.

## Provider Alias Review

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

resource "aws_s3_bucket" "west_bucket" {
  provider = aws.west
  bucket   = "example-west-bucket"
}
```

Key idea: Terraform uses the default provider unless a resource or module is explicitly
given an aliased provider.

## Non-Cloud Provider Review

```hcl
resource "random_id" "example" {
  byte_length = 8
}

resource "random_password" "db" {
  length  = 16
  special = true
}

resource "local_file" "example" {
  content  = "Hello from Terraform"
  filename = "${path.module}/output.txt"
}
```

Key idea: providers are plugins for resource types. They are not limited to cloud providers.

## HCP Terraform Topics To Review

- Remote runs vs local runs
- HCP Terraform workspaces vs CLI workspaces
- Variable sets
- Terraform variables vs environment variables
- Sensitive vs non-sensitive workspace variables
- Private registry and module versioning
- Sentinel policies
- Cost estimation and limits
- Drift detection and health assessments
- Dynamic provider credentials

## State File Exam Notes

State maps Terraform resource addresses to real infrastructure objects. It can also
contain sensitive data.

Scenario reminders:

- If someone manually deletes a managed resource, `terraform plan` usually proposes
  to recreate it.
- If a resource is removed from configuration but remains in state, Terraform plans
  to destroy it unless you use a state operation or a `removed` block.
- If a resource is renamed, Terraform may plan destroy/create unless you use a `moved`
  block or `terraform state mv`.
- Marking a variable `sensitive` hides CLI output but does not guarantee the value is
  absent from state.

## Personal Study Plan

| Topic | Confidence | Study method | Time |
| --- | --- | --- | --- |
| State commands | Yellow | Run `state list`, `show`, `mv`, `rm`, and `import` on tiny test infra. | 60 min |
| HCP Terraform | Yellow/Red | Review workspaces, variable sets, remote runs, policies, and registry. | 75 min |
| Provider aliases | Yellow | Write one AWS alias example and one module provider map. | 30 min |
| Non-cloud providers | Yellow | Create a small `random` + `local_file` config. | 30 min |
| Complex types/functions | Yellow | Practice maps, objects, `for`, `merge`, `lookup`, `toset`, and splats. | 45 min |
| Sample questions | Yellow | Complete official sample questions and explain wrong answers. | 45 min |
| Flashcards | Yellow | Create command/state/module/HCP flashcards. | 45 min |

## Five Practice Questions From This Challenge

1. A saved plan becomes stale. What should you do?
   - Regenerate the plan, review it again, then apply the new saved plan.

2. What happens if you run `terraform state rm aws_s3_bucket.logs`?
   - Terraform forgets the bucket, but the real AWS bucket remains.

3. How do you send one AWS resource to `us-west-2` while the default provider is `us-east-1`?
   - Use an aliased provider such as `aws.west` and set `provider = aws.west`.

4. Does `sensitive = true` guarantee a secret is absent from state?
   - No. It hides CLI output, but state can still contain sensitive values.

5. A PR plan says `0 to add, 0 to change, 2 to destroy`. What should happen?
   - Pause, confirm the destruction is intended, document blast radius, and require explicit approval.

## Day 23 Takeaway

My strongest areas are the workflows practiced hands-on: core commands, modules, state
basics, testing, and deployment discipline. My remaining gaps are exam-specific:
state subcommands, exact provider alias syntax, HCP Terraform details, and non-cloud
provider examples. The next study days should be targeted drills, not broad reading.
