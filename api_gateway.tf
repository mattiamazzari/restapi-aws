# Define an API gateway that triggers the Lambda function
resource "aws_api_gateway_rest_api" "API-gw" {
  name        = "lambda_rest_api"
  description = "This is the REST API for Sicilian Dishes"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "API-resource-dish" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  parent_id   = aws_api_gateway_rest_api.API-gw.root_resource_id
  path_part   = "dish"
}

resource "aws_api_gateway_resource" "API-resource-dishes" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  parent_id   = aws_api_gateway_rest_api.API-gw.root_resource_id
  path_part   = "dishes"
}

#####################################################################################################
########################### GET ALL /dishes #########################################################
#####################################################################################################

resource "aws_api_gateway_method" "GET_all_method" {
  rest_api_id   = aws_api_gateway_rest_api.API-gw.id
  resource_id   = aws_api_gateway_resource.API-resource-dishes.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "GET_all_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.API-gw.id
  resource_id             = aws_api_gateway_resource.API-resource-dishes.id
  http_method             = aws_api_gateway_method.GET_all_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.my-lambda-function.invoke_arn
}

resource "aws_api_gateway_method_response" "GET_all_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  resource_id = aws_api_gateway_resource.API-resource-dishes.id
  http_method = aws_api_gateway_method.GET_all_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "GET_all_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  resource_id = aws_api_gateway_resource.API-resource-dishes.id
  http_method = aws_api_gateway_method.GET_all_method.http_method
  status_code = aws_api_gateway_method_response.GET_all_method_response_200.status_code

  depends_on = [aws_api_gateway_integration.GET_all_lambda_integration]

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$.body'))
    {
      \"statusCode\": 200,
      \"body\": $inputRoot,
      \"headers\": {
        \"Content-Type\": \"application/json\"
      }
    }
    EOF
  }
}

#####################################################################################################
########################### GET /dish/{dishId} #########################################################
#####################################################################################################

resource "aws_api_gateway_method" "GET_one_method" {
  rest_api_id   = aws_api_gateway_rest_api.API-gw.id
  resource_id   = aws_api_gateway_resource.API-resource-dish.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "GET_one_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.API-gw.id
  resource_id             = aws_api_gateway_resource.API-resource-dish.id
  http_method             = aws_api_gateway_method.GET_one_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.my-lambda-function.invoke_arn
}

resource "aws_api_gateway_method_response" "GET_one_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  resource_id = aws_api_gateway_resource.API-resource-dish.id
  http_method = aws_api_gateway_method.GET_one_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "GET_one_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  resource_id = aws_api_gateway_resource.API-resource-dish.id
  http_method = aws_api_gateway_method.GET_one_method.http_method
  status_code = aws_api_gateway_method_response.GET_one_method_response_200.status_code

  depends_on = [aws_api_gateway_integration.GET_one_lambda_integration]

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$.body'))
    {
      \"statusCode\": 200,
      \"body\": $inputRoot,
      \"headers\": {
        \"Content-Type\": \"application/json\"
      }
    }
    EOF
  }
}

#####################################################################################################
########################### POST /dish #########################################################
#####################################################################################################

resource "aws_api_gateway_method" "POST_method" {
  rest_api_id   = aws_api_gateway_rest_api.API-gw.id
  resource_id   = aws_api_gateway_resource.API-resource-dish.id
  http_method   = "POST"
  # authorization = "NONE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.demo.id
}

resource "aws_api_gateway_integration" "POST_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.API-gw.id
  resource_id             = aws_api_gateway_resource.API-resource-dish.id
  http_method             = aws_api_gateway_method.POST_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.my-lambda-function.invoke_arn
}

resource "aws_api_gateway_method_response" "POST_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  resource_id = aws_api_gateway_resource.API-resource-dish.id
  http_method = aws_api_gateway_method.POST_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "POST_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  resource_id = aws_api_gateway_resource.API-resource-dish.id
  http_method = aws_api_gateway_method.POST_method.http_method
  status_code = aws_api_gateway_method_response.POST_method_response_200.status_code

  depends_on = [aws_api_gateway_integration.POST_lambda_integration]

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$.body'))
    {
      \"statusCode\": 200,
      \"body\": $inputRoot,
      \"headers\": {
        \"Content-Type\": \"application/json\"
      }
    }
    EOF
  }
}

#####################################################################################################
########################### PATCH /dish #########################################################
#####################################################################################################

resource "aws_api_gateway_method" "PATCH_method" {
  rest_api_id   = aws_api_gateway_rest_api.API-gw.id
  resource_id   = aws_api_gateway_resource.API-resource-dish.id
  http_method   = "PATCH"
  # authorization = "NONE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.demo.id
}

resource "aws_api_gateway_integration" "PATCH_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.API-gw.id
  resource_id             = aws_api_gateway_resource.API-resource-dish.id
  http_method             = aws_api_gateway_method.PATCH_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.my-lambda-function.invoke_arn
}

resource "aws_api_gateway_method_response" "PATCH_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  resource_id = aws_api_gateway_resource.API-resource-dish.id
  http_method = aws_api_gateway_method.PATCH_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "PATCH_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  resource_id = aws_api_gateway_resource.API-resource-dish.id
  http_method = aws_api_gateway_method.PATCH_method.http_method
  status_code = aws_api_gateway_method_response.PATCH_method_response_200.status_code

  depends_on = [aws_api_gateway_integration.PATCH_lambda_integration]

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$.body'))
    {
      \"statusCode\": 200,
      \"body\": $inputRoot,
      \"headers\": {
        \"Content-Type\": \"application/json\"
      }
    }
    EOF
  }
}

#####################################################################################################
########################### DELETE /dish #########################################################
#####################################################################################################

resource "aws_api_gateway_method" "DELETE_method" {
  rest_api_id   = aws_api_gateway_rest_api.API-gw.id
  resource_id   = aws_api_gateway_resource.API-resource-dish.id
  http_method   = "DELETE"
  # authorization = "NONE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.demo.id
}

resource "aws_api_gateway_integration" "DELETE_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.API-gw.id
  resource_id             = aws_api_gateway_resource.API-resource-dish.id
  http_method             = aws_api_gateway_method.DELETE_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.my-lambda-function.invoke_arn
}

resource "aws_api_gateway_method_response" "DELETE_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  resource_id = aws_api_gateway_resource.API-resource-dish.id
  http_method = aws_api_gateway_method.DELETE_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "DELETE_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  resource_id = aws_api_gateway_resource.API-resource-dish.id
  http_method = aws_api_gateway_method.DELETE_method.http_method
  status_code = aws_api_gateway_method_response.DELETE_method_response_200.status_code

  depends_on = [aws_api_gateway_integration.DELETE_lambda_integration]

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$.body'))
    {
      \"statusCode\": 200,
      \"body\": $inputRoot,
      \"headers\": {
        \"Content-Type\": \"application/json\"
      }
    }
    EOF
  }
}

#####################################################################################################
#####################################################################################################
#####################################################################################################

# Allowing API Gateway to Access Lambda:
# By default any two AWS services have no access to one another, until access is explicitly granted.
# For Lambda functions, access is granted using the aws_lambda_permission resource
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my-lambda-function.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.API-gw.execution_arn}/*/*"
}

# CORS

module "cors" {
  source = "./modules/cors"

  api_id            = aws_api_gateway_rest_api.API-gw.id
  api_resource_id   = aws_api_gateway_resource.API-resource-dish.id
  allow_credentials = true
}

# Deployment

resource "aws_api_gateway_deployment" "example" {

  depends_on = [
    aws_api_gateway_integration.GET_one_lambda_integration,
    aws_api_gateway_integration.GET_all_lambda_integration,
    aws_api_gateway_integration.PATCH_lambda_integration,
    aws_api_gateway_integration.POST_lambda_integration,
    aws_api_gateway_integration.DELETE_lambda_integration
  ]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.API-resource-dish,
      aws_api_gateway_method.GET_one_method,
      aws_api_gateway_integration.GET_one_lambda_integration,
      aws_api_gateway_method.GET_all_method,
      aws_api_gateway_integration.GET_all_lambda_integration,
      aws_api_gateway_method.POST_method,
      aws_api_gateway_integration.POST_lambda_integration,
      aws_api_gateway_method.PATCH_method,
      aws_api_gateway_integration.PATCH_lambda_integration,
      aws_api_gateway_method.DELETE_method,
      aws_api_gateway_integration.DELETE_lambda_integration
    ]))
  }

  rest_api_id = aws_api_gateway_rest_api.API-gw.id
}

resource "aws_api_gateway_stage" "my-prod-stage" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.API-gw.id
  stage_name    = "prod"

  depends_on = [aws_cloudwatch_log_group.rest-api-logs]
}

# Logging

resource "aws_cloudwatch_log_group" "rest-api-logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.API-gw.id}/prod"
  retention_in_days = 7
}

resource "aws_api_gateway_method_settings" "my_settings" {
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  stage_name  = aws_api_gateway_stage.my-prod-stage.stage_name
  method_path = "*/*"
  settings {
    logging_level = "INFO"
    data_trace_enabled = true
    metrics_enabled = true
  }
}

################################
#### Authentication ####
################################

resource "aws_api_gateway_authorizer" "demo" {
  name = "my_apig_authorizer2"
  rest_api_id = aws_api_gateway_rest_api.API-gw.id
  type = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.pool.arn]
}