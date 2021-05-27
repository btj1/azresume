output "storage_account_name" {
  value = azurerm_storage_account.staccount.name
}

output "cdn_endpoint_name" {
  value = azurerm_cdn_endpoint.cdn_resume.name
}

output "az_resume_rg" {
  value = azurerm_resource_group.rg.name
}

output "cdn_profile_name" {
  value = azurerm_cdn_profile.cdn.name
}

output "cdn_endpoint_hostname" {
  value = azurerm_cdn_endpoint.cdn_resume.host_name
}
output "custom_domain" {
  value = var.custom_domain
}
