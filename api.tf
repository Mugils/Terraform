locals {
  sfnapi_action_prefix = "arn:aws:apigateway:${local.region}:states:action/%s"
  apiname              = format("%s-sfn-api", local.project_name)
}

resource "aws_api_gateway_stage" "create-stage" {
  stage_name    = "v1"
  rest_api_id   = aws_api_gateway_rest_api.sfn_api.id
  deployment_id = aws_api_gateway_deployment.sfn_deployment.id
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = format("/aws/apigateway/%s", local.apiname)
  retention_in_days = 14
  depends_on        = [aws_api_gateway_rest_api.sfn_api]
}
resource "aws_api_gateway_method_settings" "exec-logs" {
  rest_api_id = aws_api_gateway_rest_api.sfn_api.id
  stage_name  = aws_api_gateway_stage.create-stage.stage_name

  method_path = "*/*"
  settings {
    logging_level      = "OFF"
    metrics_enabled    = false
    data_trace_enabled = false
  }
}

resource "aws_api_gateway_deployment" "sfn_deployment" {
  rest_api_id = aws_api_gateway_rest_api.sfn_api.id
  region      = local.region
  depends_on  = [aws_api_gateway_rest_api.sfn_api]
}

resource "aws_api_gateway_account" "api_account" {
  cloudwatch_role_arn = data.aws_iam_role.step_function_role.arn
}

resource "aws_api_gateway_rest_api" "sfn_api" {
  name        = local.apiname
  description = "REST API for Step Functions"

  body = templatefile("${path.module}/api/apigateway.yaml", {
    api-name                               = local.apiname
    step-function-action-StartExecution    = format(local.sfnapi_action_prefix, "StartExecution")
    step-function-action-DescribeExecution = format(local.sfnapi_action_prefix, "DescribeExecution")
    step-function-execution-Arn            = replace(module.step-functions.state_machine_arn, "stateMachine", "execution")
    apigateway-role-arn                    = data.aws_iam_role.step_function_role.arn
    step-function-arn                      = module.step-functions.state_machine_arn
    region                                 = local.region
  })

  depends_on = [module.step-functions]
}

output "ApiExecutionUrl" {
  value = aws_api_gateway_rest_api.sfn_api.execution_arn
}