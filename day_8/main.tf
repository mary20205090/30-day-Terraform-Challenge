# Day 8 introduces reusable Terraform modules. This root module keeps the
# provider configuration and then consumes the reusable web server cluster
# module from the local modules/ folder.

provider "aws" {
  region = var.region
}

module "webserver_cluster" {
  source = "./modules/services/webserver-cluster"

  cluster_name        = var.cluster_name
  environment         = var.environment
  instance_type       = var.instance_type
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  server_port         = var.server_port
  allowed_cidr_blocks = var.allowed_cidr_blocks
  ami_name_pattern    = var.ami_name_pattern
  ami_owner           = var.ami_owner
}

output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the load balancer created by the module"
}

output "asg_name" {
  value       = module.webserver_cluster.asg_name
  description = "The name of the Auto Scaling Group created by the module"
}
