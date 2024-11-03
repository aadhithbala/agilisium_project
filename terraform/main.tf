# Provider configuration
terraform {

  backend "s3" {
    bucket = "todo-app-terraform-state-agilisium"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"                 
    encrypt = true
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