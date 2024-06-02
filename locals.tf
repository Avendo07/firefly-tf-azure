
locals{
  location = var.location
  rg_name = azurerm_resource_group.rg.name
  tags = {
    "owners" = "naman"
    "project" = "beach"
  }
}