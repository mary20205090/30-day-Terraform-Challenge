terraform {
  required_version = ">= 1.0.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# This is a low-cost way to see Terraform manage a different provider type.
provider "docker" {}

resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = var.container_name

  ports {
    internal = 80
    external = var.external_port
  }
}
