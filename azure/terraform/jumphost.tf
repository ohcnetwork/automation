variable "admin_username" {
    type = string
    default = "ubuntu"
    description = "Administrator user name for virtual machine"
}

variable "admin_password" {
    type = string
    default = "root@1234"
    description = "Password must meet Azure complexity requirements"
}


resource "azurerm_public_ip" "jumphost-ip" {
  name                = "care-jumphost"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "jumphost-nsg" {
  name                = "care-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "care-jumphost-nic" {
  name                      = "care--jumphostnic"
  location                  = data.azurerm_resource_group.rg.location
  resource_group_name       = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "care-nic-config"
    subnet_id                     =  azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.jumphost-ip.id
  }
}

resource "azurerm_virtual_machine" "jumphost" {
  name                  = "care-jumphost"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.care-jumphost-nic.id]
  vm_size               = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  
  storage_os_disk {
    name              = "care-jumphost-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = 32
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04.0-LTS"
    version   = "latest"
  }
  

  os_profile {
    computer_name  = "care-jumphost"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

data "azurerm_public_ip" "ip" {
  name                = azurerm_public_ip.jumphost-ip.name
  resource_group_name = azurerm_virtual_machine.jumphost.resource_group_name
  depends_on          = [azurerm_virtual_machine.jumphost]
}