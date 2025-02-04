locals {
  state_machine_source = "${path.module}/states/invoke_customizations.asl.json"
  replacements_map = {
    identify_targets_function_arn              = aws_lambda_function.aft_customizations_identify_targets.arn
    execute_pipeline_function_arn              = aws_lambda_function.aft_customizations_execute_pipeline.arn
    get_pipeline_executions_function_arn       = aws_lambda_function.aft_customizations_get_pipeline_executions.arn
    invoke_provisioning_framework_function_arn = aws_lambda_function.aft_customizations_invoke_account_provisioning.arn
    maximum_concurrent_customizations          = var.maximum_concurrent_customizations
    aft_notification_arn                       = var.aft_sns_topic_arn
    aft_failure_notification_arn               = var.aft_failure_sns_topic_arn
  }
}

resource "aws_sfn_state_machine" "aft_invoke_customizations_sfn" {
  name       = "aft-invoke-customizations"
  role_arn   = aws_iam_role.aft_invoke_customizations_sfn.arn
  definition = templatefile(local.state_machine_source, local.replacements_map)
}

