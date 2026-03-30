# Day 9 focuses on versioned module usage. The provider still belongs in the
# root configuration, while the module source points to a Git repository and
# a pinned version tag.
provider "aws" {
  region = "us-west-2"
}

module "webserver_cluster" {
  source = "github.com/mary20205090/30-day-Terraform-Challenge//day_8/modules/services/webserver-cluster?ref=v0.0.1"

  cluster_name        = "webservers-dev"
  environment         = "dev"
  instance_type       = "t3.micro"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  server_port         = 8080
  allowed_cidr_blocks = ["0.0.0.0/0"]
}

output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the development load balancer"
}

output "asg_name" {
  value       = module.webserver_cluster.asg_name
  description = "The name of the development Auto Scaling Group"
}
