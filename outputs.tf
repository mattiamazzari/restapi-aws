# Test API Gateway URL
output "api_gateway_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}