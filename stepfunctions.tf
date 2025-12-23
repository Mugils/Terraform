locals {
  sfn_name = format("%s-step-function", local.project_name)
}


module "step-functions" {
  source  = "terraform-aws-modules/step-functions/aws"
  version = "5.0.2"

  name   = local.sfn_name
  region = local.region
  definition = templatefile("./step-functions/stepfunction.asl.json", {
    lambda_function_name = var.lambda_function_arn
  })
  type = "STANDARD"


  use_existing_role = true
  role_arn          = data.aws_iam_role.step_function_role.arn
}

output "StepfunctionArn" {
  value = module.step-functions.state_machine_arn
}
