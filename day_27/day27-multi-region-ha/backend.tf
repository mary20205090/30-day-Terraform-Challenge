terraform {
  backend "s3" {
    # Day 27 keeps state remote so multi-module changes use one shared source of truth.
    bucket         = "mary-mutua-day27-tf-state-use1-718417034043-20260428"
    key            = "day27/multi-region-ha/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks-day27"
    encrypt        = true
  }
}
