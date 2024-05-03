resource "aws_api_gateway_method" "_" {
  rest_api_id   = var.api_id
  resource_id   = var.api_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# aws_api_gateway_integration._
resource "aws_api_gateway_integration" "_" {
  rest_api_id = var.api_id
  resource_id = var.api_resource_id
  http_method = aws_api_gateway_method._.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

# aws_api_gateway_integration_response._
resource "aws_api_gateway_integration_response" "_" {
  rest_api_id = var.api_id
  resource_id = var.api_resource_id
  http_method = aws_api_gateway_method._.http_method
  status_code = 200

  response_parameters = local.integration_response_parameters

  depends_on = [
    aws_api_gateway_integration._,
    aws_api_gateway_method_response._,
  ]
}

# aws_api_gateway_method_response._
resource "aws_api_gateway_method_response" "_" {
  rest_api_id = var.api_id
  resource_id = var.api_resource_id
  http_method = aws_api_gateway_method._.http_method
  status_code = 200

  response_parameters = local.method_response_parameters

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_method._,
  ]
}