terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"

  backend "s3" {
    bucket         = "couchbase-tfstate-bucket"  # your bucket name
    key            = "dev/terraform.tfstate"     # path inside bucket
    region         = "us-west-1"
    dynamodb_table = "terraform-locks"           # DynamoDB table name
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
