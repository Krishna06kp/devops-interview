##############################
## Azure App Service - Main ##
##############################

# Terrform block
terraform {
  required_version = "~> 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
}

# provider block
provider "azurerm" {
  features {}
}

# Resource block - create resource group
resource "azurerm_resource_group" "appservice-rg" {
  name     = "bradyapp1-${var.app_name}-rg"
  location = var.location

  tags = {
    description = var.description
    environment = var.environment
  }
}
# Resource block - Create the App Service Plan 
resource "azurerm_service_plan" "service-plan" {
  name                = "bradyapp1-${var.environment}-${var.app_name}-serviceplan"
  resource_group_name = azurerm_resource_group.appservice-rg.name
  location            = azurerm_resource_group.appservice-rg.location
  sku_name            = "S1"
  os_type             = "Windows"
  
  tags = {
    description = var.description
    environment = var.environment
  }
}

# Resource block - Create the Web App 
resource "azurerm_windows_web_app" "app-service" {
  name                = "bradyapp1-${var.environment}-${var.app_name}-app-service"
  resource_group_name = azurerm_resource_group.appservice-rg.name
  location            = azurerm_resource_group.appservice-rg.location
  service_plan_id     = azurerm_service_plan.service-plan.id

  site_config {
      http2_enabled = "true"


      application_stack{
          current_stack = "dotnet"
          dotnet_version = "v3.0"
      }
     
    }
    tags = {
      description = var.description
      environment = var.environment
  }
}

