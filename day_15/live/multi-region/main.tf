terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# The root module owns provider configuration.
# It defines one AWS provider per region and passes them into the child module.
provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

provider "aws" {
  alias  = "replica"
  region = var.replica_region
}

data "aws_caller_identity" "current" {
  provider = aws.primary
}

resource "random_id" "app_suffix" {
  byte_length = 4
}

module "multi_region_app" {
  source = "../../modules/multi-region-app"

  # Make the bucket names globally unique before passing them into the child module.
  app_name    = "${var.app_name}-${data.aws_caller_identity.current.account_id}-${random_id.app_suffix.hex}"
  environment = var.environment

  providers = {
    aws.primary = aws.primary
    aws.replica = aws.replica
  }
}
