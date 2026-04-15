mock_provider "aws" {}

variables {
  cluster_name     = "test-cluster"
  environment      = "dev"
  project_name     = "day21-infra-workflow"
  team_name        = "EveOps"
  instance_type    = "t3.micro"
  min_size         = 1
  max_size         = 2
  desired_capacity = 1
  vpc_id           = "vpc-12345678"
  subnet_ids       = ["subnet-11111111", "subnet-22222222"]
  server_port      = 8080
  server_text      = "Hello from Day 21"
}

run "validate_asg_name_prefix" {
  command = plan

  assert {
    condition     = output.asg_name_prefix == "test-cluster-asg-"
    error_message = "ASG name prefix must include the cluster_name value."
  }
}

run "validate_instance_type" {
  command = plan

  assert {
    condition     = output.launch_template_instance_type == "t3.micro"
    error_message = "Launch template instance type must match the instance_type variable."
  }
}

run "validate_app_port" {
  command = plan

  assert {
    condition     = output.instance_ingress_port == 8080
    error_message = "Instance security group must allow ALB traffic on port 8080."
  }
}

run "reject_invalid_environment" {
  command = plan

  variables {
    environment = "qa"
  }

  expect_failures = [var.environment]
}
