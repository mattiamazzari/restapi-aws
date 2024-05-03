resource "aws_dynamodb_table" "my_dynamodb_table" {
  name         = "dishes"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "dish_id"

  attribute {
    name = "dish_id"
    type = "S"
  }

  tags = {
    Name = "dishes-table"
  }
}

locals {
  json_data = file("${path.module}/dishes.json")
  dishes    = jsondecode(local.json_data)
}

# Create a new item in the DynamoDB table for each dish.
resource "aws_dynamodb_table_item" "dishes" {
  for_each   = local.dishes
  table_name = aws_dynamodb_table.my_dynamodb_table.name
  hash_key   = aws_dynamodb_table.my_dynamodb_table.hash_key
  item       = jsonencode(each.value)
}