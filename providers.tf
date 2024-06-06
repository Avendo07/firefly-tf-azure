terraform {
  required_version = "~>1.7.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.106.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.5.1"
    }
  }
}

provider "azurerm" {
  features {}
}