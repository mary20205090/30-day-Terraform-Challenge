provider "aws" {
  region = "us-west-2"
}

module "webserver_cluster" {
  source = "../../modules/services/webserver-cluster"

  cluster_name               = "day11-web-production"
  environment                = "production"
  create_dns_record          = false
  enable_detailed_monitoring = true
}

output "environment_summary" {
  value = module.webserver_cluster.environment_summary
}

output "alarm_arn" {
  value = module.webserver_cluster.alarm_arn
}

output "dns_record_fqdn" {
  value = module.webserver_cluster.dns_record_fqdn
}
