# Hello World App Module

Composes the Day 16 networking and ASG modules into a production-grade-ish
hello-world service with:

- shared tagging
- ALB + target group
- rolling ASG deployment
- CloudWatch CPU alarm via the ASG module

## Usage

```hcl
module "hello_world_app" {
  source = "../../modules/services/hello-world-app"

  cluster_name     = "day16-dev"
  environment      = "dev"
  project_name     = "terraform-challenge"
  team_name        = "platform"
  instance_type    = "t3.micro"
  min_size         = 1
  max_size         = 2
  desired_capacity = 1
  vpc_id           = data.aws_vpc.default.id
  subnet_ids       = data.aws_subnets.default.ids
}
```
