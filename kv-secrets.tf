resource "azurerm_key_vault_secret" "db_user" {
  name                = "dbUser"
  key_vault_id        = azurerm_key_vault.kv.id
  value = data.local_sensitive_file.db_user.content
}

resource "azurerm_key_vault_secret" "db_secret" {
  name                = "dbSecret"
  key_vault_id        = azurerm_key_vault.kv.id
  value = data.local_sensitive_file.db_secret.content
}

resource "azurerm_key_vault_secret" "app_secret" {
  name                = "appSecret"
  key_vault_id        = azurerm_key_vault.kv.id
  value = data.local_sensitive_file.app_secret.content
}

data "local_sensitive_file" "db_user"{
  filename = ".db_user"
}

data "local_sensitive_file" "db_secret"{
  filename = ".db_secret"
}

data "local_sensitive_file" "app_secret"{
  filename = ".app_secret"
}