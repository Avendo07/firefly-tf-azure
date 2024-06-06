resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.0.0.0/24"]
  location            = local.location
  name                = "${var.app_name}-vnet"
  resource_group_name = local.rg_name
}

resource "azurerm_subnet" "app_subnet" {
  address_prefixes     = ["10.0.0.0/28"]
  name                 = "app-subnet"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "db_subnet" {
  address_prefixes     = ["10.0.0.32/28"]
  name                 = "db-subnet"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  /*delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }*/
}

resource "azurerm_private_dns_zone" "dns" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = local.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_link" {
  name                = "dns_vnet_link"
  resource_group_name = local.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_a_record" "dns_record" {
  name                = "mysql-db"
  records             = [azurerm_private_endpoint.pep.private_service_connection[0].private_ip_address]
  resource_group_name = local.rg_name
  ttl                 = 300
  zone_name           = azurerm_private_dns_zone.dns.name
}