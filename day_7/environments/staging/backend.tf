terraform {
  backend "s3" {
    bucket         = "mary-mutua-30day-terraform-state-20260325-a1b2"
    key            = "environments/staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
