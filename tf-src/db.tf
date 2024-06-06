resource "azurerm_mysql_flexible_server" "db_server" {
  name                   = "${var.app_name}-mysql-db-server"
  resource_group_name    = local.rg_name
  location               = local.location
  administrator_login    = data.local_sensitive_file.db_user.content
  administrator_password = data.local_sensitive_file.db_secret.content
  sku_name               = "B_Standard_B1s"
  zone = "2"
#   delegated_subnet_id   = azurerm_subnet.db_subnet.id
}

resource "azurerm_mysql_flexible_database" "mysql_db" {
  name                = "${var.app_name}-db"
  resource_group_name = local.rg_name
  server_name         = azurerm_mysql_flexible_server.db_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_server_configuration" "secure_connection" {
  name                = "require_secure_transport"
  resource_group_name = local.rg_name
  server_name         = azurerm_mysql_flexible_server.db_server.name
  value               = "OFF"
}

resource "azurerm_mysql_flexible_server_configuration" "connections" {
  name                = "max_user_connections"
  resource_group_name = local.rg_name
  server_name         = azurerm_mysql_flexible_server.db_server.name
  value               = "2"
}

resource "azurerm_private_endpoint" "pep" {
  location            = local.location
  name                = "${var.app_name}-db-pep"
  resource_group_name = local.rg_name
  subnet_id           = azurerm_subnet.db_subnet.id
  private_service_connection {
    is_manual_connection           = false
    name                           = "${var.app_name}-db-psc"
    private_connection_resource_id = azurerm_mysql_flexible_server.db_server.id
    subresource_names = ["mysqlServer"]
  }
}