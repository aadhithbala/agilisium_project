# Provider configuration
terraform {

  backend "s3" {
    bucket = var.terraform_state_bucket
    key    = "terraform/terraform.tfstate"    # Path within the bucket for the state file
    region = "ap-south-1"                 # AWS region for the bucket
    encrypt = true                        # Enable encryption for state file
  }

  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1" # Mumbai region
}