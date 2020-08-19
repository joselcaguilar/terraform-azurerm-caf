locals {
  vnets = merge(module.virtual_network, var.networking_objects)
}


module "virtual_network" {
  source = "/tf/caf/modules/terraform-azurerm-caf-virtual-network"

  for_each = var.networking

  prefix                            = var.global_settings.prefix
  convention                        = lookup(each.value, "convention", var.global_settings.convention)
  location                          = lookup(each.value, "region", null) == null ? azurerm_resource_group.rg[each.value.resource_group_key].location : var.global_settings.regions[each.value.region]
  resource_group_name               = azurerm_resource_group.rg[each.value.resource_group_key].name
  networking_object                 = each.value
  network_security_group_definition = var.network_security_group_definition
  tags                              = var.tags
  diagnostics                       = local.diagnostics
}

