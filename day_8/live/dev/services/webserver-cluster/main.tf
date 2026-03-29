# The root module configures the provider. Reusable modules should not define
# providers directly.
provider "aws" {
  region = "us-west-2"
}

# The dev environment reuses the shared module with smaller, lower-cost
# settings that are better suited to development work.
module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

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
