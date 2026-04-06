output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Public API server endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "cluster_region" {
  description = "AWS region where the EKS cluster is deployed"
  value       = var.region
}

output "service_hostname" {
  description = "Hostname created by the Kubernetes LoadBalancer service"
  value = try(
    kubernetes_service.nginx.status[0].load_balancer[0].ingress[0].hostname,
    "(service hostname not available yet)"
  )
}
