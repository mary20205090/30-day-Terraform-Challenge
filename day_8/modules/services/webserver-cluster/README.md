# Webserver Cluster Module

This reusable Terraform module creates a simple load-balanced web server
cluster on AWS using an Application Load Balancer, target group, listener,
security groups, a launch template, and an Auto Scaling Group. It is a
refactor of the repeated clustered infrastructure patterns used earlier in the
challenge so the same infrastructure can be reused across environments with
different inputs instead of copy-pasting Terraform code.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `cluster_name` | `string` | none | The name used as the prefix for cluster resources. |
| `environment` | `string` | none | Environment label applied to resources such as `dev` or `production`. |
| `instance_type` | `string` | `"t3.micro"` | EC2 instance type for the cluster nodes. |
| `min_size` | `number` | none | Minimum number of EC2 instances in the Auto Scaling Group. |
| `max_size` | `number` | none | Maximum number of EC2 instances in the Auto Scaling Group. |
| `desired_capacity` | `number` | none | Desired number of EC2 instances when the cluster is created. |
| `server_port` | `number` | `8080` | Application port used by the cluster instances. |
| `allowed_cidr_blocks` | `list(string)` | `["0.0.0.0/0"]` | CIDR blocks allowed to access the load balancer. |
| `ami_name_pattern` | `string` | `"ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"` | AMI name pattern used to look up a recent Ubuntu image. |
| `ami_owner` | `string` | `"099720109477"` | AWS account ID that owns the Ubuntu AMI. |

## Outputs

| Name | Description |
|------|-------------|
| `alb_dns_name` | The domain name of the load balancer. |
| `asg_name` | The name of the Auto Scaling Group. |
| `alb_security_group_id` | The ID of the load balancer security group. |
| `instance_security_group_id` | The ID of the instance security group. |
| `target_group_arn` | The ARN of the load balancer target group. |
| `server_port` | The application port used by the cluster instances. |
| `alb_zone_id` | The Route 53 zone ID of the load balancer. |

## Usage

Minimum example:

```hcl
provider "aws" {
  region = "us-west-2"
}

module "webserver_cluster" {
  source = "./modules/services/webserver-cluster"

  cluster_name     = "webservers-dev"
  environment      = "dev"
  min_size         = 2
  max_size         = 4
  desired_capacity = 2
}
```

## Known Limitations and Gotchas

- This module reuses the default VPC and default subnets instead of creating
  custom networking.
- The module should be called from a root configuration that defines the AWS
  provider. Reusable modules should not define providers directly.
- If you ever reference files inside the module, use `path.module` so the path
  resolves correctly from the module folder.
- Be careful mixing inline blocks with separate resources for the same AWS
  object type. For reusable modules, separate resources are usually more
  flexible.
