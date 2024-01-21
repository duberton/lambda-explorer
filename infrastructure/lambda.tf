module "lambda_explorer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.5.0"

  memory_size                             = 128
  description                             = "lambda-explorer"
  attach_async_event_policy               = true
  attach_tracing_policy                   = true
  attach_policy_statements                = true
  create_lambda_function_url              = false
  create_async_event_config               = true
  create_current_version_allowed_triggers = true
  tracing_mode                            = "Active"
  timeout                                 = 10
  function_name                           = "lambda-explorer"
  handler                                 = "main"
  runtime                                 = "go1.x"
  publish                                 = true
  source_path                             = "../main"
  destination_on_failure                  = aws_sqs_queue.async_sqs_failure.arn
  destination_on_success                  = aws_sqs_queue.async_sqs_success.arn
  maximum_retry_attempts                  = 1
  environment_variables = {
    NAME = "lambda-explorer"
  }

  policy_statements = {
    lambda = {
      effect = "Allow",
      actions = [
        "lambda:InvokeFunction",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:PublishMessage",
        "dynamodb:DescribeStream",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:ListStreams"
      ],
      resources = [
        aws_sqs_queue.trigger.arn,
        aws_sqs_queue.async_sqs_failure.arn,
        aws_sqs_queue.async_sqs_success.arn
      ]
    }
  }

  tags = {
    name = "lambda-explorer"
  }

  allowed_triggers = {
    sqs = {
      principal  = "sqs.amazonaws.com"
      service    = "sqs"
      source_arn = aws_sqs_queue.trigger.arn
    }
    dynamodb = {
      principal  = "dynamodb.amazonaws.com"
      source_arn = module.dynamodb_table.dynamodb_table_stream_arn
    }
  }

  event_source_mapping = {
    sqs = {
      enabled                            = true
      event_source_arn                   = aws_sqs_queue.trigger.arn
      maximum_batching_window_in_seconds = 5
      batch_size                         = 2
      function_response_types            = ["ReportBatchItemFailures"]
    }
    dynamodb = {
      event_source_arn  = module.dynamodb_table.dynamodb_table_stream_arn
      starting_position = "LATEST"
      filter_criteria = {
        pattern = jsonencode({
          eventName : ["INSERT"]
        })
      }
    }
  }

}
