resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  depends_on = [azurerm_resource_group.rg]

  name                = var.vnet_name
  address_space       = var.address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "web" {
  depends_on = [azurerm_virtual_network.vnet]

  lifecycle {
    create_before_destroy = true
  }

  name                 = var.web_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.web_subnet_prefix]
}

resource "azurerm_subnet" "app" {
  depends_on = [azurerm_virtual_network.vnet]

  name                 = var.app_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.app_subnet_prefix]
}

resource "azurerm_subnet" "db" {
  depends_on = [azurerm_virtual_network.vnet]

  name                 = var.db_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.db_subnet_prefix]
}

resource "azurerm_public_ip" "web" {
  depends_on = [azurerm_resource_group.rg]

  lifecycle {
    create_before_destroy = true
  }

  count               = var.create_web_public_ip ? 1 : 0
  name                = var.web_public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "web" {
  depends_on = [azurerm_subnet.web, azurerm_public_ip.web]

  lifecycle {
    create_before_destroy = true
  }

  name                = "nic-${var.web_vm_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-web"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_web_public_ip ? azurerm_public_ip.web[0].id : null
  }
}

resource "azurerm_network_interface" "app" {
  depends_on = [azurerm_subnet.app]

  lifecycle {
    create_before_destroy = true
  }

  name                = "nic-${var.app_vm_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-app"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "db" {
  depends_on = [azurerm_subnet.db]

  lifecycle {
    create_before_destroy = true
  }

  name                = "nic-${var.db_vm_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-db"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "web" {
  depends_on = [azurerm_network_interface.web]

  name                            = var.web_vm_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.web.id]
  disable_password_authentication = false



  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}

resource "azurerm_linux_virtual_machine" "app" {
  depends_on = [azurerm_network_interface.app]

  name                            = var.app_vm_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.app.id]
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}

resource "azurerm_linux_virtual_machine" "db" {
  depends_on = [azurerm_network_interface.db]

  name                            = var.db_vm_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.db.id]
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}
