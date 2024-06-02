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
