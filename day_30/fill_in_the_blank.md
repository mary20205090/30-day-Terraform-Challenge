# Day 30 Fill-in-the-Blank Review

This file records the 20 fill-in-the-blank precision questions used on Day 30, my answers, and the corrected answers.

Unlike multiple-choice questions, fill-in-the-blank questions force recall. Use this file to test exact Terraform command syntax, argument names, and behavior that can be easy to recognize but harder to retrieve from memory.

## Score

- Questions attempted: `20`
- Correct: `19`
- Score: `95%`

## Questions and Answers

| # | Prompt | My Answer | Correct Answer | Result |
|---:|---|---|---|---|
| 1 | The command to check formatting without making changes is `terraform ___`. | `fmt -check` | `fmt -check` | Correct |
| 2 | The lifecycle rule that prevents Terraform from destroying a resource is `___ = true`. | `prevent_destroy` | `prevent_destroy` | Correct |
| 3 | The expression for the current workspace name is `terraform.___`. | `workspace` | `workspace` | Correct |
| 4 | The S3 backend argument used to enable server-side encryption is `___`. | `server_side_encryption_configuration` | `encrypt` | Incorrect |
| 5 | The `for_each` meta-argument requires a map or a ___. | `set` | `set` | Correct |
| 6 | The command that removes a resource from state without destroying the real infrastructure is `terraform state ___`. | `rm` | `rm` | Correct |
| 7 | The provider version constraint `~> 2.0` allows versions `>= 2.0.0` and `< ___`. | `3.0` | `3.0.0` | Correct |
| 8 | A `data` block reads ___ infrastructure; a `resource` block manages ___ infrastructure. | `existing, real` | `existing, managed` | Correct |
| 9 | `terraform init -upgrade` can update provider selections recorded in the ___ file. | `lock.hcl` | `.terraform.lock.hcl` | Correct |
| 10 | To apply a saved plan named `myplan.tfplan`, run `terraform apply ___`. | `myplan.tfplan` | `myplan.tfplan` | Correct |
| 11 | The command to list all resources currently tracked in state is `terraform state ___`. | `list` | `list` | Correct |
| 12 | The command to show details for a specific state address is `terraform state ___`. | `show` | `show` | Correct |
| 13 | The command to move a state binding from one address to another is `terraform state ___`. | `mv` | `mv` | Correct |
| 14 | The meta-argument that creates multiple instances using numeric indexes is ___. | `count` | `count` | Correct |
| 15 | The meta-argument that creates multiple instances using stable keys is ___. | `for_each` | `for_each` | Correct |
| 16 | The block used to declare provider source and version constraints is `required_`. | `providers` | `providers` | Correct |
| 17 | The file commonly used for automatic variable values is `terraform.___`. | `tfvars` | `tfvars` | Correct |
| 18 | Files ending in `.___.tfvars` are automatically loaded. | `auto` | `auto` | Correct |
| 19 | The command to authenticate Terraform CLI to HCP Terraform is `terraform ___`. | `login` | `login` | Correct |
| 20 | The environment variable that enables Terraform logging is `___`. | `TF_LOG` | `TF_LOG` | Correct |

## Corrections and Nuance

### S3 Backend Encryption

The S3 backend encryption argument is:

```hcl
encrypt = true
```

`server_side_encryption_configuration` is related to configuring encryption on an actual S3 bucket resource, not the S3 backend argument.

### Data vs Resource Wording

A `data` block reads existing infrastructure or service data. A `resource` block manages infrastructure through a provider. The answer `existing, real` was close enough for the exercise, but `existing, managed` is the cleaner exam wording.

### Lock File Name

The complete provider lock file name is:

```text
.terraform.lock.hcl
```

Remembering the full name matters because the exam may distinguish it from `terraform.tfstate`, `terraform.tfvars`, or backend configuration files.
