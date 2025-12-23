locals {
  project_name = "tf-demo-project"
  region       = "us-east-1"
}

data "aws_iam_role" "step_function_role" {
  name = aws_iam_role.step_function_role.name
}

