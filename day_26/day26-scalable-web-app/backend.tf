# Reference backend configuration for Day 26.
# The active backend lives in envs/dev/backend.tf because Terraform only loads
# configuration from the directory where you run terraform.
terraform {
  backend "s3" {
    bucket         = "mary-mutua-day26-tf-state-use1-718417034043-20260423"
    key            = "day26/scalable-web-app/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks-day26"
    encrypt        = true
  }
}
