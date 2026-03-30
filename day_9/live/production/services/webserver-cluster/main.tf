# Production also uses the versioned module source, but it can later be
# pinned to a different version than dev to allow safer rollout testing.
provider "aws" {
  region = "us-west-2"
}

module "webserver_cluster" {
  source = "github.com/mary20205090/30-day-Terraform-Challenge//day_8/modules/services/webserver-cluster?ref=v0.0.1"

  cluster_name        = "webservers-production"
  environment         = "production"
  instance_type       = "t3.small"
  min_size            = 4
  max_size            = 10
  desired_capacity    = 4
  server_port         = 8080
  allowed_cidr_blocks = ["0.0.0.0/0"]
}

output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the production load balancer"
}

output "asg_name" {
  value       = module.webserver_cluster.asg_name
  description = "The name of the production Auto Scaling Group"
}
