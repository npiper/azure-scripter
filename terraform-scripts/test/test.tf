provider "azurerm" {
  features {}
}

resource "azurerm_recovery_services_vault" "example" {
  name                = var.recovery_vault_name
  resource_group_name = var.resource_group_name
  location            = var.recovery_vault_location
  sku                 = var.recovery_vault_sku
}

data "azurerm_virtual_machine" "example" {
  name                = "MyUKSouthVM"
  resource_group_name = var.source_vm_resource_group
}

resource "azurerm_recovery_services_protected_vm" "example" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = data.azurerm_virtual_machine.example.id
  source_vm_arm_id    = data.azurerm_virtual_machine.example.id
  source_vm_location  = data.azurerm_virtual_machine.example.location
  os_type             = var.os_type
  protection_policy_id = var.protection_policy_id
  protected_vm_name   = var.protected_vm_name
  source_vm_name      = var.source_vm_name
}

# Other resources and configurations can be added as needed
