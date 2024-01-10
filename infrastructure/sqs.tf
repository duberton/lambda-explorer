resource "aws_sqs_queue" "trigger" {
  name = "lambda-explorer-sqs-trigger"
}

resource "aws_sqs_queue" "async_sqs_success" {
  name = "lambda-explorer-sqs-async-success"
}

resource "aws_sqs_queue" "async_sqs_failure" {
  name = "lambda-explorer-sqs-async-failure"
}
