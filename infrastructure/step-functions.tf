locals {
  definition = <<SFN
{
  "Comment": "State Machine example with various state types",
  "StartAt": "Pass State",
  "States": {
    "Pass State": {
      "Comment": "A Pass state passes its input to its output, without performing work. Pass states are useful when constructing and debugging state machines.",
      "Type": "Pass",
      "Next": "Wait State"
    },
    "Wait State": {
      "Comment": "A Wait state delays the state machine from continuing for a specified time. You can choose either a relative time, specified in seconds from when the state begins, or an absolute end time, specified as a timestamp.",
      "Type": "Wait",
      "Seconds": 3,
      "Next": "Choice State"
    },
    "Choice State": {
      "Comment": "A Choice state adds branching logic to a state machine.",
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.name",
          "StringEquals": "Eduardo",
          "Next": "Succeed State"
        },
        {
          "Variable": "$.name",
          "StringEquals": "Gabriela",
          "Next": "Parallel State"
        },
        {
          "Variable": "$.name",
          "StringEquals": "Pedro",
          "Next": "Lambda Explorer"
        }
      ],
      "Default": "Error Handling State"
    },
    "Parallel State": {
      "Comment": "A Parallel state can be used to create parallel branches of execution in your state machine.",
      "Type": "Parallel",
      "Next": "Succeed State",
      "Branches": [
        {
          "StartAt": "Branch 1",
          "States": {
            "Branch 1": {
              "Type": "Pass",
              "Parameters": {
                "comment.$": "States.Format('Branch 1 Processing of Choice {}', $.name)"
              },
              "End": true
            }
          }
        },
        {
          "StartAt": "Branch 2",
          "States": {
            "Branch 2": {
              "Type": "Pass",
              "Parameters": {
                "comment.$": "States.Format('Branch 2 Processing of Choice {}', $.name)"
              },
              "End": true
            }
          }
        }
      ]
    },
    "Lambda Explorer": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "${module.lambda_explorer.lambda_function_name}",
        "Payload.$": "$"
      },
      "Next": "Succeed State"
    },
    "Succeed State": {
      "Type": "Succeed",
      "Comment": "A Succeed state stops an execution successfully. The Succeed state is a useful target for Choice state branches that don't do anything but stop the execution."
    },
    "Error Handling State": {
      "Type": "Pass",
      "Parameters": {
        "error.$": "States.Format('{} is an invalid Choice.',$.name)"
      },
      "Next": "Fail State"
    },
    "Fail State": {
      "Type": "Fail"
    }
  }
}
SFN
}

module "step_function" {
  source = "terraform-aws-modules/step-functions/aws"

  name       = "step-lambda-explorer"
  definition = local.definition

  logging_configuration = {
    include_execution_data = true
    level                  = "ALL"
  }

  service_integrations = {
    lambda = {
      lambda = [module.lambda_explorer.lambda_function_arn_static]
    }

    xray = {
      xray = true
    }
  }

  tags = {
    Pattern = "terraform-lambda-sfn"
    Module  = "step_function"
  }
}
