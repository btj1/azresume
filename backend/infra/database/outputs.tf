output "cosmosdb_connectionstrings" {
   value = azurerm_cosmosdb_account.counterdb.connection_strings
   sensitive   = true
}