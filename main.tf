resource "azurerm_resource_group" "RG20" {
    name = "RG0001"
  location = "West europe"
}
resource "azurerm_virtual_network" "VNET20" {
    name = "VNET0001"
    resource_group_name = azurerm_resource_group.RG20.name
  location = azurerm_resource_group.RG20.location
  address_space = [ "10.0.0.0/16" ]

dynamic  "Subnets" {
    name = "Subnet0001"
    virtual_network_name = azurerm_virtual_network.VNET20.name
    resource_group_name = azurerm_resource_group.RG20.name
    address_prefixes = [ "10.0.0.0/24" ]
  
}
dynamic  "Subnets" {
    name = "Subnet0002"
    virtual_network_name = azurerm_virtual_network.VNET20.name
    resource_group_name = azurerm_resource_group.RG20.name
    address_prefixes = [ "10.1.0.0/24" ]
  
}
resource "azurerm_network_interface" "NIC20" {
    name = "NIC0001"
    resource_group_name = azurerm_resource_group.RG20.name
  location = azurerm_resource_group.RG20.location
  ip_configuration {
    name = "PIP"
    subnet_id = azurerm_subnet.Subnet20.id
    private_ip_address_allocation = "Dynamic"
  }
}
  resource "azurerm_linux_virtual_machine" "VM20" {
    name = "VM0001"
    resource_group_name = azurerm_resource_group.RG20.name
    location = azurerm_resource_group.RG20.location
    size = "Standard_F2"
    admin_username = "sumit"
    admin_password = "Sumit@123456"
    disable_password_authentication = "false"
    network_interface_ids = [azurerm_network_interface.NIC20.id]
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference {
      publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
    }
    
  }