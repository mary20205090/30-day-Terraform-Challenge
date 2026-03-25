# Day 6 - Inspecting Terraform State

Day 6 focused on understanding what Terraform state actually stores and how it changes as infrastructure is created and destroyed.

## What I Deployed

For this lab, I deployed a simple AWS security group in the default VPC.

This was enough to inspect:

- how Terraform records a resource in `terraform.tfstate`
- how `terraform state list` summarizes tracked resources
- how `terraform state show` exposes detailed resource attributes
- what happens to the state file after `terraform destroy`

## Terraform Files

- `main.tf`
  Deploys a simple security group for state inspection

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

## Cleanup

The demo security group was destroyed at the end of the lab.
