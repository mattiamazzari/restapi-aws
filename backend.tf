terraform {
  backend "s3" {
    bucket = "my-api-gateway-lambda-terraform-state"
    region = "eu-west-3"
    key    = "API-Gateway/terraform.tfstate"
  }
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
    }
  }
}