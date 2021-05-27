## <https://www.terraform.io/docs/providers/azurerm/index.html>
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.58.0"
    }   
  }

  backend "azurerm" {
    resource_group_name  = "rg-azure-tf-state"
    storage_account_name = "tfstatejfnaca5j643sk"
    container_name       = "tfstate-backend"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
