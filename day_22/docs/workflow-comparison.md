# Day 22 Workflow Comparison

| Component | Application Code | Infrastructure Code |
| --- | --- | --- |
| Source of truth | Git repository | Git repository |
| Local run | `npm start` / `python app.py` | `terraform plan` |
| Artifact | Docker image / binary | Tagged Terraform code plus saved `.tfplan` per workspace |
| Versioning | Semantic version tag | Semantic version tag |
| Automated tests | Unit + integration tests | `terraform test` + Terratest |
| Policy enforcement | Linting / SAST | Sentinel policies |
| Cost gate | N/A | Terraform Cloud cost estimation policy |
| Promotion | Image promoted across environments | Same tagged module/config version promoted across environments |
| Deployment | CI/CD pipeline | `terraform apply <plan>` |
| Rollback | Redeploy previous image | Revert config and apply a reviewed rollback plan |

Important nuance: a saved `.tfplan` is tied to the exact state snapshot and
workspace where it was generated. In practice, teams promote the same tagged
Terraform code or module version across environments, then generate and review a
saved plan for each target workspace.
