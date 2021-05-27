## <https://www.terraform.io/docs/providers/azurerm/index.html>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.42.0"
    }
  }

  backend "s3" {
    bucket = "tc-remotestate-36583"
    region = "eu-central-1"
    key    = "terraform-aws/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region

}