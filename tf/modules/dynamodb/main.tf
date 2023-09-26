resource "aws_dynamodb_table" "users" {
  name         = "${var.app_name}-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "username"
  range_key    = "dateOfBirth"

  attribute {
    name = "username"
    type = "S"
  }

  attribute {
    name = "dateOfBirth"
    type = "S"
  }

  tags = {
    Name = "${var.app_name}-dynamodb-table"
  }
}
