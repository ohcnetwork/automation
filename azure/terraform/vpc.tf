variable "resource_group_name" {
  default = "RG-Coronasafe"
}
# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "care"
    address_space       = ["10.0.0.0/16"]
    location            = "centralindia"
    resource_group_name = var.resource_group_name
}
