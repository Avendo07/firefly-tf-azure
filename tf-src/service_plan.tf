resource "azurerm_service_plan" "service_plan" {
  name                = "${var.app_name}SP"
  location            = local.location
  resource_group_name = local.rg_name
  os_type             = "Linux"
  sku_name            = var.sku
  tags                = local.tags

}

resource "azurerm_linux_web_app" "web_app" {
  name                = "${var.app_name}WebApp"
  location            = local.location
  resource_group_name = local.rg_name
  service_plan_id     = azurerm_service_plan.service_plan.id
  virtual_network_subnet_id = azurerm_subnet.app_subnet.id
  site_config {
    always_on = false
    application_stack {
      docker_image_name = var.docker-image
    }
  }
  app_settings = {
    "APP_KEY" = data.local_sensitive_file.app_key.content
    "APP_PASSWORD" = data.local_sensitive_file.app_secret.content
    "DB_DATABASE" = azurerm_mysql_flexible_database.mysql_db.name
    "DB_CONNECTION"="mysql"
    "DB_HOST" = "${azurerm_private_dns_a_record.dns_record.name}.${azurerm_private_dns_zone.dns.name}"#"mysql-db.privatelink.mysql.database.azure.com"
    "DB_USERNAME" = data.local_sensitive_file.db_user.content
    "DB_PASSWORD" = data.local_sensitive_file.db_secret.content
    "DEFAULT_LANGUAGE" = "en_US"
    "DEFAULT_LOCALE" = "equal"
    "TRUSTED_PROXIES" = "**"
    "TZ" = "Asia/Kolkata"
  }

  tags = local.tags
}