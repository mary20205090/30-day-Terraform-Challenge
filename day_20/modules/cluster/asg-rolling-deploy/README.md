# ASG Rolling Deploy Module

Deploys a small, reusable Auto Scaling Group with:

- launch template
- ELB-aware health checks
- `create_before_destroy`
- CloudWatch CPU alarm
- SNS topic for alerts
- explicit instance security group rules

## Usage

```hcl
module "asg" {
  source = "../../modules/cluster/asg-rolling-deploy"

  cluster_name     = "example-dev"
  environment      = "dev"
  project_name     = "terraform-challenge"
  team_name        = "platform"
  instance_type    = "t3.micro"
  min_size         = 1
  max_size         = 2
  desired_capacity = 1
  vpc_id           = data.aws_vpc.default.id
  subnet_ids       = data.aws_subnets.default.ids
  target_group_arns = [aws_lb_target_group.app.arn]
  alb_security_group_id = module.alb.alb_security_group_id
  health_check_type = "ELB"
  user_data         = file("${path.module}/user-data.sh")
}
```
