module "lambda_explorer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.5.0"


  description                = "lambda-explorer"
  create_lambda_function_url = true
  attach_tracing_policy      = true
  tracing_mode               = "Active"
  timeout                    = 30
  function_name              = "lambda-explorer"
  handler                    = "main"
  runtime                    = "go1.x"
  publish                    = true
  source_path                = "../main"
  environment_variables = {
    NAME = "lambda-explorer"
  }

  tags = {
    name = "lambda-explorer"
  }
}
