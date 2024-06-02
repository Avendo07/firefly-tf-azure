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
#       docker_registry_url = "https://hub.docker.com"
    }
  }
  app_settings = {
    "APP_KEY" = "NW9FYPe2NKav99Jg5TkfsIulvj6X4UOe"
    "DB_DATABASE" = "fireflyiii-db"
#     "DB_HOST" = azurerm_private_endpoint.pep.custom_dns_configs[0].fqdn
    "DB_USERNAME" = data.local_sensitive_file.db_user.content
    "DB_PASSWORD" = data.local_sensitive_file.db_secret.content
    "APP_PASSWORD" = data.local_sensitive_file.app_secret.content
    "DEFAULT_LANGUAGE" = "en_US"
    "DEFAULT_LOCALE" = "equal"
    "TRUSTED_PROXIES" = "**"
    "TZ" = "Asia/Kolkata"
  }

/*  connection_string {
    name  = "DB_CONNECTION"
    type  = "MySQL"
    value = "Server=${azurerm_private_endpoint.pep.ip_configuration};Database=your-database-name;User Id=mysqladminun@${azurerm_mysql_flexible_server.example.name};Password=your-password;SslMode=Required;"
  }*/

  tags = local.tags
}