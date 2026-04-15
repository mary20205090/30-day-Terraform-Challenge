# ALB Module

Deploys a reusable Application Load Balancer with:

- explicit HTTP ingress rules
- shared tagging
- listener output for downstream services

## Usage

```hcl
module "alb" {
  source = "../../modules/networking/alb"

  alb_name            = "hello-world-dev"
  environment         = "dev"
  project_name        = "terraform-challenge"
  team_name           = "platform"
  vpc_id              = data.aws_vpc.default.id
  subnet_ids          = data.aws_subnets.default.ids
  allowed_cidr_blocks = ["0.0.0.0/0"]
}
```
