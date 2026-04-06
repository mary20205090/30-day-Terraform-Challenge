terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

# This VPC uses public subnets only to avoid NAT gateway charges during the lab.
# That keeps cost lower, but production clusters usually use private worker subnets.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs            = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets = var.public_subnets

  enable_nat_gateway = false
  single_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  tags = {
    Environment = var.environment
    Challenge   = "30DayTerraform"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access          = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    default = {
      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desired_size
      instance_types = [var.node_instance_type]
      subnet_ids     = module.vpc.public_subnets
    }
  }

  tags = {
    Environment = var.environment
    Challenge   = "30DayTerraform"
  }
}

# The Kubernetes provider uses the EKS API endpoint and the AWS CLI token helper.
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", var.region]
  }
}

resource "kubernetes_namespace" "day15" {
  metadata {
    name = "day15"
  }

  depends_on = [module.eks]
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.day15.metadata[0].name

    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = var.nginx_replicas

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"

          port {
            container_port = 80
          }
        }
      }
    }
  }

  depends_on = [module.eks]
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.day15.metadata[0].name
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
  }

  depends_on = [module.eks, kubernetes_deployment.nginx]
}
