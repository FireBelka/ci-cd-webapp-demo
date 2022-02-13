terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "ci-cd-web-app-demo"
  location = "eastus"
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "appserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind = "Linux"
  reserved = true
  sku {
    tier = "Premiumv2"
    size = "P1v2"
  }
}

resource "azurerm_app_service" "demo" {
  name                = "web-app-tt-aa--dd"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
  site_config {
    linux_fx_version  = "DOCKER|smth.azurecr.io/ci-cd-demo:latest"
  }
  app_settings = {
      "DOCKER_REGISTRY_SERVER_URL" = ...,
      "DOCKER_REGISTRY_SERVER_USERNAME" = ...,
      "DOCKER_REGISTRY_SERVER_PASSWORD" = ...,
  }
}

resource "azurerm_app_service_slot" "staging-slot" {
  name                = "staging"
  app_service_name    = azurerm_app_service.demo.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
  site_config {
    linux_fx_version  = "DOCKER|smth.azurecr.io/ci-cd-demo:latest"
  }
  app_settings = {
      "DOCKER_REGISTRY_SERVER_URL" = ...,
      "DOCKER_REGISTRY_SERVER_USERNAME" = ...,
      "DOCKER_REGISTRY_SERVER_PASSWORD" = ....,
  }
}
