# Day 4 - Configurable Web Server

This lab refactors a simple EC2 web server so the deployment is driven by input variables instead of hardcoded values.

## Outcome

This lab was successfully deployed and tested in AWS.

The EC2 instance launched correctly, the startup script ran, and the web page was reachable in the browser on the configured application port.

## What This Lab Covers

- Configure the AWS provider with a variable-driven region
- Parameterize the web server port and EC2 instance type
- Launch a simple EC2-backed web server with a configurable name and environment
- Use outputs to quickly find the deployed server after `terraform apply`

## Terraform Concepts Practiced

### Input variables

`variable` blocks declare inputs Terraform should accept so the same configuration can be reused across environments.

Examples from this lab:

- `region`
- `server_port`
- `instance_type`
- `server_name`
- `environment`

Variables are referenced with:

```hcl
var.<name>
```

Examples:

```hcl
var.region
var.server_port
var.instance_type
```

## Files

- [main.tf](./main.tf): Main Terraform configuration for the lab
- [variables.tf](./variables.tf): Input variables used by the lab

## Resources Used

This lab creates or manages:

- 1 security group
- 1 EC2 instance

## What Was Configurable

The final deployment used variables to control:

- AWS region
- EC2 instance type
- application port
- server name
- environment label
- AMI lookup settings

## Why Input Variables Matter

Using input variables makes Terraform more flexible because important settings do not need to be hardcoded in `main.tf`.

Instead of fixing values directly in the resource blocks, Terraform can accept different values for:

- AWS region
- instance type
- server port
- resource names
- environment labels

This makes the same Terraform code reusable for multiple environments and use cases.

## Commands Used

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Preview changes:

```bash
terraform plan
```

Apply changes:

```bash
terraform apply
```

Destroy resources after the lab:

```bash
terraform destroy
```

## Troubleshooting Notes

### Security group access

The EC2 instance is reachable only on the configured `server_port`, so the security group must allow that port.

### Default VPC usage

This lab uses the default VPC and its default subnets so the focus stays on input variables instead of custom networking.

## AWS Console Verification

After a successful apply, check:

- `VPC > Security Groups`
- `EC2 > Instances`
- `EC2 > Instances` public DNS or public IP

## Browser Verification

After `terraform apply`, the server was successfully reached in the browser using the EC2 public DNS name and the configured port:

```text
http://<public-dns>:8080
```

The page displayed:

- server name
- environment
- region
- server port

## Key Takeaways

- `resource` creates or manages infrastructure
- `variable` defines configurable input values
- `var.<name>` is how Terraform reads input variables
- Input variables help avoid hardcoding values
- `user_data` can configure the server automatically during instance boot
- `terraform plan` helps review changes before applying
- `terraform destroy` is important for cleanup, especially on Free Tier

## Reflection

This lab made the difference between a static Terraform configuration and a reusable one much clearer. Instead of rewriting resource blocks, the infrastructure behavior changed through input variables.

## Cleanup Reminder

After finishing the lab:

1. Run `terraform destroy`
2. Confirm `terraform state list` returns nothing
3. Verify in AWS Console that the security group and instance are gone
