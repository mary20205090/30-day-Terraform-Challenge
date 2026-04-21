terraform {
  backend "s3" {
    bucket         = "mary-mutua-day25-terraform-state-718417034043"
    key            = "day25/static-website/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks-day25"
    encrypt        = true
  }
}
