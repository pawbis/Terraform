resource "azurerm_virtual_network" "vnet" {
  name                = "MTFvnet"
  address_space       = ["10.0.0.0/18"]
  location            = azurerm_resource_group.mrg.location
  resource_group_name = azurerm_resource_group.mrg.name

  tags = {
    Environment = "dev",
    Project     = "ops"
  }
}
resource "azurerm_subnet" "snet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.mrg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/26"]
}
resource "azurerm_network_security_group" "ssh" {
  name                = "ssh"
  location            = azurerm_resource_group.mrg.location
  resource_group_name = azurerm_resource_group.mrg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh-source-address
    destination_address_prefix = "*"
  }
}

