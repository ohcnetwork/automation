data "azurerm_resource_group" "rg" {
  name = "RG-Coronasafe"
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "care"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  location            = "centralindia"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet_1" {
  name                 = "care-subnet-1"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/18"]
}

resource "azurerm_subnet" "subnet_2" {
  name                 = "care-subnet-2"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.64.0/18"]
}

resource "azurerm_subnet" "subnet_3" {
  name                 = "care-subnet-3"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.128.0/18"]
}

resource "azurerm_subnet" "postgres-subnet" {
  name                 = "postgresql-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.192.0/18"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_nat_gateway" "nat_1" {
  name                = "nat-nat-1"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_nat_gateway" "nat_2" {
  name                = "nat-nat-2"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_nat_gateway" "nat_3" {
  name                = "nat-nat-3"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}


resource "azurerm_subnet_nat_gateway_association" "nat_assoc_1" {
  subnet_id      = azurerm_subnet.subnet_1.id
  nat_gateway_id = azurerm_nat_gateway.nat_1.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_assoc_2" {
  subnet_id      = azurerm_subnet.subnet_2.id
  nat_gateway_id = azurerm_nat_gateway.nat_2.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_assoc_3" {
  subnet_id      = azurerm_subnet.subnet_3.id
  nat_gateway_id = azurerm_nat_gateway.nat_3.id
}