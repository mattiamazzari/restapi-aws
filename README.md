# A Step-by-Step Guide On Deploying REST API using API Gateway, Lambda, DynamoDB, Cognito — Terraform

![restapiaws (1)](https://github.com/mattiamazzari/restapi-aws/assets/71759564/f11db44a-70ef-43ca-9ca9-9f943777d409)

The goal is to build an hands-on project which can be used on different kind of situations and which is very common in the real world, in which almost all the applications are based on microservices in modular lego blocks.

In particular, the goal is to create an API hosted in an API gateway with the backend on Lambda and a database on DynamoDB. The Lambda Function will contain the logic to perform CRUD operations (CREATE, READ, UPDATE, DELETE) on the DynamoDB table. Then additionally we will restrict public access to some routes using Amazon Cognito because writing operations are dangerous for the database.

Since I was born in Sicily, a beautiful island in Italy, we will create a simple API for managing a list of traditional Sicilian dishes.

Link to the documentation:
[A Step-by-Step Guide On Deploying REST API using API Gateway, Lambda, DynamoDB, Cognito — Terraform](https://medium.com/@mattiamazzari/a-step-by-step-guide-on-deploying-rest-api-using-api-gateway-lambda-cognito-terraform-f277814d048e)
