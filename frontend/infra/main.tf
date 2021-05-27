locals {
  env_prefix              = "${var.projectname}-${var.environment}-${var.location_short_code}"
  env_prefix_no_separator = "${var.projectname}${var.environment}${var.location_short_code}"
}

## <https://www.terraform.io/docs/providers/azurerm/r/resource_group.html>
resource "azurerm_resource_group" "rg" {
  name     = "${local.env_prefix}-frontend-rg"
  location = var.location
  tags = {
    environment = var.environment
    version     = var.appversion
    product     = var.projectname
  }

}
## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_
resource "azurerm_storage_account" "staccount" {
  name                      = "${local.env_prefix_no_separator}stor"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = "true"
  static_website {

    index_document = "index.html"

  }

  tags = {
    environment = var.environment
    version     = var.appversion
    product     = var.projectname
  }
}

## Configure Azure CDN Profile and Endpoint and point towards storage account

resource "azurerm_cdn_profile" "cdn" {
  name                = var.cdn_profile
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "cdn_resume" {
  name                = var.cdn_endpoint_name
  profile_name        = azurerm_cdn_profile.cdn.name
  location            = azurerm_cdn_profile.cdn.location
  resource_group_name = azurerm_resource_group.rg.name
  origin_host_header  = azurerm_storage_account.staccount.primary_web_host

  origin {
    name      = azurerm_storage_account.staccount.name
    host_name = azurerm_storage_account.staccount.primary_web_host
  }

  tags = {
    environment = var.environment
    version     = var.appversion
    product     = var.projectname
  }

  ## Add Delivery rule that Enforces HTTPS and Redirects HTTP traffic to HTTPS

  delivery_rule {
    name  = "EnforceHTTPS"
    order = "1"

    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }

    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }

}