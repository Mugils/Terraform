resource "aws_iam_role" "step_function_role" {
  name               = format("%s-sfn-role", local.project_name)
  assume_role_policy = file("./policies/custom-exec-policy.json.tpl")
}

resource "aws_iam_policy" "step_function_policy" {
  name   = "${local.project_name}-sfn-policy"
  policy = file("./policies/permission-policy.json.tpl")
}

resource "aws_iam_role_policy_attachment" "attach-policies" {
  policy_arn = aws_iam_policy.step_function_policy.arn
  role       = aws_iam_role.step_function_role.name
}

