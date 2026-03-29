# Day 7 - State Isolation with Terraform Workspaces

Day 7 focused on using Terraform workspaces to isolate environments while reusing the same Terraform code.

## What a Workspace Means

A Terraform workspace lets you use:

- the same Terraform configuration
- the same backend
- different state files

This means the code stays the same, but each workspace keeps its own separate record of infrastructure.

In simple terms:

- one folder
- one codebase
- multiple isolated states

## Do Workspaces Use the Same Remote Backend?

Yes, all the workspaces use the same remote backend type and the same S3 bucket.

But they do not share the same state file.

Instead, each workspace gets its own separate state path inside the backend.

That means:

- `dev` has its own state
- `staging` has its own state
- `production` has its own state

So the environments use the same backend, but not the same tracked infrastructure state.

## What I Built

For this lab, I used one Terraform configuration in `day_7/main.tf` to deploy an EC2 instance whose behavior changes based on the active workspace.

The configuration uses:

- `terraform.workspace`
- a map of instance types
- workspace-based tags

So:

- `dev` used one EC2 size and environment tag
- `staging` used a different EC2 size and environment tag
- `production` has its own isolated workspace too

## What I Verified

I created and switched between workspaces using:

```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new production
terraform workspace list
terraform workspace select dev
```

I then deployed in:

- `dev`
- `staging`

I confirmed in S3 that Terraform created separate workspace paths under the backend, including:

- `env:/dev/`
- `env:/staging/`
- `env:/production/`

This showed that each workspace had isolated state, even though all of them used the same Terraform code and backend bucket.

## Key Day 7 Lesson

Workspaces isolate state, not code.

That means:

- the same Terraform files can be reused
- each workspace keeps its own separate state
- Terraform can manage dev, staging, and production-like environments without mixing their state together

## State Isolation via File Layouts

I also created a file-layout version of the same idea under:

- `day_7/environments/dev`
- `day_7/environments/staging`
- `day_7/environments/production`

In this approach, each environment has its own:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `backend.tf`

The biggest difference from workspaces is that file layout isolates both:

- the state file
- the entry-point folder

That means each environment is run independently from its own directory.

Example backend keys:

- `environments/dev/terraform.tfstate`
- `environments/staging/terraform.tfstate`
- `environments/production/terraform.tfstate`

This approach is easier to reason about in production because:

- each environment is more explicit
- there is less chance of applying changes in the wrong environment
- dev, staging, and production are separated more clearly

## Workspace vs File Layout

### Workspaces

- same code
- same backend bucket
- different state files
- faster to switch between similar environments

### File Layouts

- separate folders
- separate backend keys
- separate state files
- clearer and safer for production-style separation

## Practical Day 7 Takeaway

Workspaces are useful when the environments are very similar and you want quick switching.

File layouts are usually easier to trust for real production use because the environment boundary is clearer in both the code structure and the state path.
