module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name             = "lambda-explorer-db"
  hash_key         = "pk"
  range_key        = "sk"
  billing_mode     = "PAY_PER_REQUEST"
  table_class      = "STANDARD"
  # stream_enabled   = true
  # stream_view_type = "NEW_IMAGE"

  attributes = [
    {
      name = "pk"
      type = "S"
    },
    {
      name = "sk"
      type = "S"
    }
  ]
}
