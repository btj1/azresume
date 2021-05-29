locals {
  env_prefix              = "${var.projectname}-${var.environment}-${var.location_short_code}"
  env_prefix_no_separator = "${var.projectname}${var.environment}${var.location_short_code}"
}

## <https://www.terraform.io/docs/providers/azurerm/r/resource_group.html>
resource "azurerm_resource_group" "rg2" {
  name     = "${local.env_prefix}-backend-rg"
  location = var.location
  tags = {
    environment = var.environment
    version     = var.appversion
    product     = var.projectname
  }

}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "counterdb" {
  name                = "counterdb-azbtjresume"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  enable_free_tier    = "true"
  
  consistency_policy {
    consistency_level       = "Eventual"
   
  }

  geo_location {
    location          = azurerm_resource_group.rg2.location
    failover_priority = 0
  }

}

resource "azurerm_cosmosdb_sql_database" "counter_database" {
  name                = var.db_name
  resource_group_name = azurerm_cosmosdb_account.counterdb.resource_group_name
  account_name        = azurerm_cosmosdb_account.counterdb.name
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "counter_container" {
  name                  = var.db_container
  resource_group_name   = azurerm_cosmosdb_account.counterdb.resource_group_name
  account_name          = azurerm_cosmosdb_account.counterdb.name
  database_name         = azurerm_cosmosdb_sql_database.counter_database.name
  partition_key_path    = "/index"
  partition_key_version = 1
  throughput            = 400
}

## Create the infrastructure for the Azure Function

resource "azurerm_storage_account" "azfuncsa" {
  name                     = "func${local.env_prefix_no_separator}"
  resource_group_name      = azurerm_resource_group.rg2.name
  location                 = azurerm_resource_group.rg2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "counterapideployment" {
    name = "azfunc-sc-${local.env_prefix}"
    storage_account_name = azurerm_storage_account.azfuncsa.name
    container_access_type = "private"
}

resource "azurerm_storage_blob" "funccode" {
    name = "counterapi.zip"
    storage_account_name = azurerm_storage_account.azfuncsa.name
    storage_container_name = azurerm_storage_container.counterapideployment.name
    type = "Block"
    source = var.func_source
}

data "azurerm_storage_account_sas" "sasaccess" {
    connection_string = "${azurerm_storage_account.azfuncsa.primary_connection_string}"
    https_only = true
    start = "2021-05-01"
    expiry = "2021-12-31"
    resource_types {
        object = true
        container = false
        service = false
    }
    services {
        blob = true
        queue = false
        table = false
        file = false
    }
    permissions {
        read = true
        write = false
        delete = false
        list = false
        add = false
        create = false
        update = false
        process = false
    }
}

resource "azurerm_app_service_plan" "azfuncsp" {
  name                = "azure-functions-${local.env_prefix}-service-plan"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "counterapi" {
  name                       = "visitorcountbtjaz2"
  location                   = azurerm_resource_group.rg2.location
  resource_group_name        = azurerm_resource_group.rg2.name
  app_service_plan_id        = azurerm_app_service_plan.azfuncsp.id
  storage_account_name       = azurerm_storage_account.azfuncsa.name
  storage_account_access_key = azurerm_storage_account.azfuncsa.primary_access_key
  version = "~3"  
  
  app_settings = {
        https_only = true
        FUNCTIONS_WORKER_RUNTIME = "python"
        FUNCTION_APP_EDIT_MODE = "readonly"
        HASH = "${base64encode(filesha256("${var.func_source}"))}"
        WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.azfuncsa.name}.blob.core.windows.net/${azurerm_storage_container.counterapideployment.name}/${azurerm_storage_blob.funccode.name}${data.azurerm_storage_account_sas.sasaccess.sas}"
        CosmosDbConnectionString = azurerm_cosmosdb_account.counterdb.connection_strings[0]
    }
  site_config {
    cors {
      allowed_origins = ["https://${var.custom_domain}]
    }
  } 
}

