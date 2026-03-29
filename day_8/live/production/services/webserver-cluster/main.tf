# The production root module uses the same reusable module, but with different
# inputs to reflect production-style scaling needs.
provider "aws" {
  region = "us-west-2"
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

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
