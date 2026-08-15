output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "web_vm_id" {
  value = azurerm_linux_virtual_machine.web.id
}

output "app_vm_id" {
  value = azurerm_linux_virtual_machine.app.id
}

output "db_vm_id" {
  value = azurerm_linux_virtual_machine.db.id
}
