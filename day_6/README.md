# Day 6 - Inspecting Terraform State and Configuring Remote State

Day 6 focused on understanding what Terraform state actually stores, how it changes as infrastructure is created and destroyed, and how to move that state from local storage to a remote backend.

## What I Deployed

For this lab, I deployed a simple AWS security group in the default VPC.

This was enough to inspect:

- how Terraform records a resource in `terraform.tfstate`
- how `terraform state list` summarizes tracked resources
- how `terraform state show` exposes detailed resource attributes
- what happens to the state file after `terraform destroy`

## Terraform Files

- `main.tf`
  Deploys a simple security group for state inspection and uses the S3 backend
- `bootstrap/main.tf`
  Creates the S3 bucket and DynamoDB table needed for remote state

## Why There Is a bootstrap Folder

The name `bootstrap` is not required by Terraform. It is just a common and useful convention.

Why bootstrap?

`bootstrap` just means "the thing that sets up the thing we need first."

It is called `bootstrap` because this folder is used to create the backend infrastructure first.

That was necessary because of the bootstrap problem:

- Terraform cannot use an S3 backend until the S3 bucket already exists
- Terraform cannot use DynamoDB locking until the DynamoDB table already exists

So the workflow becomes:

- `day_6/bootstrap`
  creates the backend infrastructure
- `day_6`
  uses that backend infrastructure

In other words:

- the bootstrap configuration starts with local state
- it creates the S3 bucket and DynamoDB table
- the main Day 6 configuration then stores its state remotely in S3

## Why It Is Called Remote State

It is called remote state because the Terraform state file is no longer stored only on the local machine.

Instead, it is stored in a shared remote location:

- Amazon S3 stores the state file
- DynamoDB provides state locking

## What a Remote Backend Means

A backend is the place where Terraform stores its state.

If Terraform stores state in the local folder, that is a local backend.

If Terraform stores state in a shared service such as Amazon S3, that is a remote backend.

In this Day 6 lab, the remote backend is:

- S3 bucket
  `mary-mutua-30day-terraform-state-20260325-a1b2`
- DynamoDB table
  `terraform-state-locks`

What each one does:

- S3 stores the actual `terraform.tfstate` file
- DynamoDB prevents two Terraform runs from changing the same state at the same time

So when someone asks "what is the remote backend here?", the answer is:

- the S3 backend configured in `day_6/main.tf`
- backed by the S3 bucket for state storage
- and the DynamoDB table for state locking

That makes it safer for team collaboration because:

- the state is not tied to one laptop
- it is easier to share
- it is harder to lose
- locking helps prevent two people from updating the same state at the same time

## Commands I Used

```bash
terraform init
terraform plan
terraform apply
terraform state list
terraform state show aws_security_group.example
cat terraform.tfstate
terraform destroy
```

For the remote state setup, I also used:

```bash
cd bootstrap
terraform init
terraform apply

cd ..
terraform init
```

## What I Observed in terraform.tfstate

Terraform state stored:

- the resource type and name
- the provider reference
- the resource ID
- attributes such as `name`, `description`, `vpc_id`, `tags`, `ingress`, and `egress`
- output values such as `security_group_id`

This showed that the state file is Terraform's record of what it manages in AWS.

## What terraform state list Showed

`terraform state list` gave a clean summary of tracked objects in state.

This was useful because it showed, in a compact form, exactly what Terraform was currently managing.

## What terraform state show Showed

`terraform state show aws_security_group.example` displayed the full recorded attributes for the security group in a much more readable format than raw JSON.

It exposed details such as:

- the security group ID
- the VPC ID
- tag values
- ingress rule details
- egress rule details

## What Happened After terraform destroy

After `terraform destroy`, the resource was removed from Terraform state.

The `terraform.tfstate` file was still present, but it became almost empty and contained only minimal metadata, with:

- empty `outputs`
- empty `resources`

This confirmed that Terraform removes destroyed resources from state when they no longer exist.

## Key Day 6 Lessons

- Terraform state stores the mapping between Terraform code and real infrastructure
- resource attributes and IDs are recorded in the state file
- `terraform state list` gives a summary view of tracked resources
- `terraform state show` gives a detailed view of one tracked resource
- after `terraform destroy`, tracked resources are removed from state
- remote state means storing Terraform state outside the local machine
- a bootstrap configuration is often used to create the backend infrastructure first
- S3 stores the remote state file and DynamoDB provides locking

## Cleanup

The demo security group was destroyed at the end of the lab.
