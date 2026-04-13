# Day 20: Workflow for Deploying Application Code

This day maps the trusted application deployment flow to Terraform infrastructure delivery.

Reference: Chapter 10 of *Terraform: Up & Running* (Yevgeniy Brikman), section **"A Workflow for Deploying Application Code"**.

## Day 20 Standalone Layout

- `day_20/modules/*`: copied module stack (standalone for today)
- `day_20/live/dev/*`: Day 20 dev root module
- `day_20/docs/*`: supporting docs/templates for PR and review

## Task 3: Seven-Step Workflow Simulation

### Step 1: Version control
What: Keep Terraform in Git and use PR-only merges to `main`.
Why: Infrastructure changes need review and traceability.

Manual check in GitHub:
- `Settings -> Branches -> Branch protection rules -> main`
- Require PR before merge.

### Step 2: Run locally
What changed:
- `server_text` updated from `Hello from Day 20 v2` to `Hello from Day 20 v3`
  in `day_20/live/dev/variables.tf`.

Commands:

```bash
terraform -chdir=day_20/live/dev init
terraform -chdir=day_20/live/dev validate
terraform -chdir=day_20/live/dev plan -out=day20.tfplan
```

Result:
- `validate` passed
- plan saved as `day_20/live/dev/day20.tfplan`
- plan summary: `15 to add, 0 to change, 0 to destroy`

### Step 3: Make code change on feature branch

```bash
git checkout -b update-app-version-day20
git add day_20 .gitignore
git commit -m "Day 20: update app response to v3 and simulate deployment workflow"
git push origin update-app-version-day20
```

### Step 4: Submit for review
Create PR from `update-app-version-day20` to `main`.

Add plan output to PR comment:

```bash
terraform -chdir=day_20/live/dev show -no-color day20.tfplan
```

Reviewer focus:
- no unexpected deletes
- expected user-data response update (`v3`)
- resource count is expected

### Step 5: Run automated tests
Day 20 local unit test command:

```bash
terraform -chdir=day_20/modules/services/webserver-cluster test
```

Result:
- `4 passed, 0 failed`

Note:
- Unit tests are module-local via `.tftest.hcl` in `day_20/modules/services/webserver-cluster`.
- A separate `test/` folder is not required for native `terraform test`.

PR check expectation:
- GitHub Actions runs unit tests on PR.
- Integration + E2E run on push/merge to `main` (per your Day 18 workflow policy).

### Step 6: Merge and release

```bash
git checkout main
git pull --rebase origin main
git merge --ff-only update-app-version-day20
git tag -a "v1.3.0" -m "Update app response to v3"
git push origin main
git push origin v1.3.0
```

### Step 7: Deploy

```bash
terraform -chdir=day_20/live/dev apply day20.tfplan
terraform -chdir=day_20/live/dev output -raw alb_dns_name
curl -s http://$(terraform -chdir=day_20/live/dev output -raw alb_dns_name)
```

Expected response includes:
- `Hello from Day 20 v3`

Cleanup after validation:

```bash
terraform -chdir=day_20/live/dev destroy
aws ec2 describe-instances --filters "Name=tag:ManagedBy,Values=terraform" "Name=instance-state-name,Values=pending,running,stopping,stopped" --query "Reservations[*].Instances[*].InstanceId"
aws elbv2 describe-load-balancers --query "LoadBalancers[*].LoadBalancerArn"
```

Expected after cleanup:
- Both AWS queries should return `[]`.

## Task 4: Terraform Cloud Setup

Add this block in `day_20/live/dev/main.tf` when ready to migrate state:

```hcl
terraform {
  cloud {
    organization = "YOUR_TFC_ORG"

    workspaces {
      name = "day20-webserver-cluster-dev"
    }
  }
}
```

Then run:

```bash
terraform -chdir=day_20/live/dev login
terraform -chdir=day_20/live/dev init
```

In Terraform Cloud workspace variables:
- Environment variables (sensitive): `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- Terraform variables: `cluster_name`, `instance_type`, `environment`, etc.

## Task 5: Terraform Cloud Private Registry

1. Create module repo: `terraform-aws-webserver-cluster`
2. Push module code
3. Tag release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

4. In Terraform Cloud: `Registry -> Publish -> Module`
5. Consume module as:

```hcl
module "webserver_cluster" {
  source  = "app.terraform.io/YOUR_ORG/webserver-cluster/aws"
  version = "1.0.0"
}
```

## Task 6: Workflow Comparison (Application vs Infrastructure)

| Step | Application Code | Infrastructure Code | Key Difference |
|---|---|---|---|
| 1. Version control | Git for source code | Git for `.tf` files | State file is NOT in Git |
| 2. Run locally | `npm start` / `python app.py` | `terraform plan` | Plan previews change; no running app |
| 3. Make changes | Edit source files | Edit `.tf` files | Changes affect real cloud resources |
| 4. Review | Code diff in PR | Plan output in PR | Reviewer must understand infrastructure impact |
| 5. Automated tests | Unit tests, linting | `terraform test`, Terratest | Infra tests may create paid resources |
| 6. Merge and release | Merge + tag | Merge + tag | Module consumers pin versions |
| 7. Deploy | CI/CD pipeline | `terraform apply` | Apply needs trusted, locked environment |
