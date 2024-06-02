resource "azurerm_key_vault" "kv" {
  name                = "${var.app_name}-kv"
  location            = local.location
  resource_group_name = local.rg_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  access_policy {
    tenant_id           = data.azurerm_client_config.current.tenant_id
    object_id           = data.azurerm_client_config.current.object_id
    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]
  }
  tags = local.tags
}

data "azurerm_client_config" "current" {}