resource "azurerm_virtual_machine" "demo-vm"{
	name = "demo-linvm"
	location = var.location
	resource_group_name = azurerm_resource_group.mrg.name
	network_interface_ids = [azurerm_network_interface.ani.id]
	vm_size = "Standard-A1_v2"
	
	delete_os_disk_on_termination = true
	delete_data_disks_on_termination = true

	storage_image_reference{
		publisher = "Canonical"
		offer = "UbuntuServer"
		sku = "16.04-LTS"
		version = "latest"
	}
	storage_os_disk { 
		name = "osdisk1"
		caching = "ReadWrite"
		create_option = "FromImage"
		managed_disk_type = "Standard_LRS"
	}
	os_profile {
		computer_name = "demo-vm-instance"
		admin_username = "demo"
		#admin_password = "demo"
	}
	os_profile_linux_config {
		disable_password_authentication = true
		ssh_keys{
			key_data = file("mykey.pub")
			path = "home/terraform/.ssh/authorized_keys"
		}
	}
}
resource "azurerm_network_interface" "ani"{
	name = "ani1"
	location = var.location
	resource_group_name = azurerm_resource_group.mrg.name

	ip_configuration{
		name = "przyklad1"
		subnet_id = azurerm_subnet.snet.id
		private_ip_address_allocation = "Dynamic"
		public_ip_address_id = azurerm_public_ip.api.id
	}
}
resource "azurerm_public_ip" "api" {
	name = "przyklad1-pub-ip"
	location = var.location
	resource_group_name = azurerm_resource_group.mrg.name
	allocation_method = "Dynamic"
}
