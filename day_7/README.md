# Day 7 - State Isolation with Terraform Workspaces and File Layouts

Day 7 focused on two ways of isolating Terraform state:

- Terraform workspaces
- file layout isolation

I also used the `terraform_remote_state` data source so one configuration could read outputs from another.

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

I also updated the file-layout folders to use a reusable `region` variable instead of hardcoding the provider region. This makes it easier to change regions later without editing the provider block in multiple places.

The biggest difference from workspaces is that file layout isolates both:

- the state file
- the entry-point folder

That means each environment is run independently from its own directory.

Example backend keys:

- `environments/dev/terraform.tfstate`
- `environments/staging/terraform.tfstate`
- `environments/production/terraform.tfstate`

For this lab, I kept the environments in the same AWS region (`us-west-2`) on purpose. That made the exercise simpler and easier to compare while still proving that file-layout isolation works through separate folders and separate backend keys.

This approach is easier to reason about in production because:

- each environment is more explicit
- there is less chance of applying changes in the wrong environment
- dev, staging, and production are separated more clearly

I tested the file-layout approach by running Terraform independently from separate folders, including:

- `day_7/environments/dev`
- `day_7/environments/production`

This showed that each directory could manage its own infrastructure and its own state path without depending on workspace switching.

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

## Using the Remote State Data Source

I also added a `terraform_remote_state` example to show how one configuration can read outputs from another state file.

In this lab:

- `dev` exposes outputs such as `vpc_id` and `subnet_id`
- `production` reads those outputs from the dev state file

That means production can reuse values from another configuration without directly managing that other configuration's resources.

This is useful when infrastructure is split into separate layers, for example:

- networking layer
- application layer
- database layer

The key lesson is:

- one Terraform configuration should expose values with `output`
- another configuration can read those values using `terraform_remote_state`

In this lab:

- `dev` exported `vpc_id` and `subnet_id`
- `production` read those outputs from the `dev` state file
- `production` then reused the remote `subnet_id` when creating its own EC2 instance

That proved separate configurations can stay isolated while still sharing selected values safely through outputs.

## What I Confirmed in S3

For workspaces, Terraform created separate state paths such as:

- `env:/dev/`
- `env:/staging/`
- `env:/production/`

For file layouts, Terraform used separate backend keys such as:

- `environments/dev/terraform.tfstate`
- `environments/production/terraform.tfstate`

This showed that both approaches isolate state, but file layouts make the separation more explicit in the directory structure and backend configuration.

## Final Day 7 Takeaway

Workspaces are useful when environments are very similar and you want quick switching with the same codebase.

File layouts are usually easier to trust for real production use because the environment boundary is clearer in both the folder structure and the backend key.

`terraform_remote_state` helps connect separate configurations by letting one configuration read outputs from another without merging their state files.

## Cleanup Note

Destroying the backend S3 bucket can behave differently depending on what is still inside it.

- if the bucket only has current objects and Terraform can remove them cleanly, `force_destroy = true` may be enough
- if versioning is enabled and old object versions or delete markers still exist, AWS may still return `BucketNotEmpty`

That means a versioned bucket can look empty in the normal S3 view but still fail to delete until all versions and delete markers are gone.
