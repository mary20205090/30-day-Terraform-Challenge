# Day 4 Summary

Day 4 focused on making Terraform configurations more reusable and more realistic.

## Main Topics Covered

- Terraform input variables
- Terraform data sources
- refactoring a single web server to be configurable
- extending a single server into a clustered deployment
- verifying infrastructure in both Terraform and AWS
- cleaning up cloud resources after testing

## What I Built

### 1. Configurable Web Server

A single EC2-based web server that used input variables for:

- region
- instance type
- server port
- server name
- environment values

This lab showed how Terraform can stay DRY by changing inputs instead of rewriting resource blocks.

### 2. Clustered Web Server

A more production-style deployment using:

- Application Load Balancer
- Target Group
- Listener
- Launch Template
- Auto Scaling Group

This lab showed how requests can go through a load balancer to multiple EC2 instances instead of hitting one instance directly.

## Key Concepts Learned

### Variables

Variables make Terraform configurations reusable.

Instead of hardcoding values directly in `main.tf`, values can be declared in `variables.tf` and referenced with:

```hcl
var.<name>
```

### Data Sources

Data sources let Terraform look up information that already exists in AWS.

Examples used during Day 4 included:

- availability zones
- default VPC information
- AMI lookup information

### Single Server vs Cluster

Single server:

- easier to understand
- fewer resources
- direct browser-to-instance access

Clustered server:

- more moving parts
- better scalability
- better availability
- browser traffic goes to the load balancer first

## Practical Lessons

- `terraform plan` should always be reviewed before `terraform apply`
- `terraform apply` can partially succeed, so cleanup matters
- `terraform destroy` is especially important when using AWS Free Tier
- AWS Console verification is useful alongside Terraform outputs
- understanding grows a lot faster once the deployed page actually loads in the browser

## Blog Notes

Day 4 felt challenging because it combined multiple new ideas at once: variables, data sources, scaling, load balancing, state awareness, and cleanup. But both labs worked in the end, which made the concepts much easier to connect.

The biggest shift in understanding was this:

- configurable infrastructure changes behavior through variables
- scalable infrastructure changes architecture through additional AWS components
