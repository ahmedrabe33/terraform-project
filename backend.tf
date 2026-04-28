terraform {
  backend "s3" {
    bucket         = "my-terraform-bucket-mego3"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# Note: The actual backend configuration will be initialized with terraform init -backend-config
# This file serves as a template and variables will be replaced during initialization
