terraform {
  backend "s3" {
    # The active root runs from envs/prod, so this backend must point to the real Day 27 bucket.
    bucket         = "mary-mutua-day27-tf-state-use1-718417034043-20260428"
    key            = "day27/multi-region-ha/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks-day27"
    encrypt        = true
  }
}
