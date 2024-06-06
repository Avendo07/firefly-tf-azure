resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = "fireflyiii-rg"
  tags = local.tags
}