module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus            = false
  create_archives       = true
  attach_lambda_policy  = true
  attach_tracing_policy = true
  lambda_target_arns    = [module.lambda_explorer.lambda_function_arn]

  rules = {
    lambda = {
      description = "post to a lambda"
      event_pattern = jsonencode(
        {
          "source" : ["com.duberton.lambda"],
          "detail-type" : ["detail"]
        }
      )
      state = "ENABLED"
    }
  }

  targets = {
    lambda = [
      {
        name       = "send-to-lambda"
        arn        = module.lambda_explorer.lambda_function_arn
        input_path = "$.detail"
      }
    ]
  }

  archives = {
    lambda = {
      event_source_arn = data.aws_cloudwatch_event_bus.this.arn
      description      = "1 day retention"
      retention_days   = 1
      event_pattern = jsonencode(
        {
          "source" : ["com.duberton.lambda"],
          "detail-type" : ["detail"]
        }
      )
    }
  }

  schedules = {
    lambda-cron = {
      description         = "trigger every 50 minutes"
      schedule_expression = "cron(0/50 * * * ? *)"
      timezone            = "America/Sao_Paulo"
      arn                 = module.lambda_explorer.lambda_function_arn
      input               = jsonencode({ "name" : "Eduardo" })
    }
  }
}

resource "aws_lambda_permission" "event_bridge_permission" {
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_explorer.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = module.eventbridge.eventbridge_rule_arns["lambda"]
}

data "aws_cloudwatch_event_bus" "this" {
  name = "default"
}
