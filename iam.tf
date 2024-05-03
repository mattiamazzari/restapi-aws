# Assume Role policy
data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Define IAM role and attach the Assume Role Policy
resource "aws_iam_role" "lambda-iam-role" {
  name               = "lambda_role"
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
}

# Attach a IAM Service Role to the IAM role we just defined
# AWSLambdaBasicExecutionRole grants minimal permissions to the Lambda Function
# (write logs about execution, errors, debug, ...)
resource "aws_iam_role_policy_attachment" "terraform_lambda_policy" {
  role       = aws_iam_role.lambda-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach a custom policy to the IAM role for accessing DynamoDB
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name   = "lambda_dynamodb_policy"
  role   = aws_iam_role.lambda-iam-role.name
  policy = file("${path.module}/lambda_dynamodb_policy.json")
}