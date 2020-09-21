terraform {
    required_version = "> 0.12.0"
}

provider "azurerm" {
    version = ">=2.0.0"
    features {}
}

resource "random_id" "server" {
  keepers = {
    azi_id = 1
  }
  byte_length = 8
}

resource "azurerm_resource_group" "primary_region_resource_group" {
  name     = var.primary_region_resource_group
  location = var.primary_region
}

resource "azurerm_app_service_plan" "primary_region_app_service_plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.primary_region_resource_group.location
  resource_group_name = azurerm_resource_group.primary_region_resource_group.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "primary_region_web_app" {
  name                = format("%s-%s", var.primary_region_web_app_name, random_id.server.hex)
  location            = azurerm_resource_group.primary_region_resource_group.location
  resource_group_name = azurerm_resource_group.primary_region_resource_group.name
  app_service_plan_id = azurerm_app_service_plan.primary_region_app_service_plan.id

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.14"
  }

}

resource "azurerm_traffic_manager_profile" "primary_region_traffic_manager" {
  name                   = "MyTmProfile"
  resource_group_name    = azurerm_resource_group.primary_region_resource_group.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = random_id.server.hex
    ttl           = 30
  }

  monitor_config {
    protocol                     = "http"
    port                         = 80
    path                         = "/"
  }
}

resource "azurerm_traffic_manager_endpoint" "primary_region_endpoint" {
  name                = "Region1EndPoint"
  resource_group_name = azurerm_resource_group.primary_region_resource_group.name
  profile_name        = azurerm_traffic_manager_profile.primary_region_traffic_manager.name
  target_resource_id  = azurerm_app_service.primary_region_web_app.id
  type                = "azureEndpoints"
}

resource "azurerm_resource_group" "secondary_region_resource_group" {
  name     = var.secondary_region_resource_group
  location = var.secondary_region
}

resource "azurerm_app_service_plan" "secondary_region_app_service_plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.secondary_region_resource_group.location
  resource_group_name = azurerm_resource_group.secondary_region_resource_group.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "secondary_region_web_app" {
  name                = format("%s-%s", var.secondary_region_web_app_name, random_id.server.hex)
  location            = azurerm_resource_group.secondary_region_resource_group.location
  resource_group_name = azurerm_resource_group.secondary_region_resource_group.name
  app_service_plan_id = azurerm_app_service_plan.secondary_region_app_service_plan.id

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.14"
  }

}

resource "azurerm_traffic_manager_endpoint" "secondary_region_endpoint" {
  name                = "Region2EndPoint"
  resource_group_name = azurerm_resource_group.primary_region_resource_group.name
  profile_name        = azurerm_traffic_manager_profile.primary_region_traffic_manager.name
  target_resource_id  = azurerm_app_service.secondary_region_web_app.id
  type                = "azureEndpoints"
}

