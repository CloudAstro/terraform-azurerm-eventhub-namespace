resource "azurerm_eventhub_namespace" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  capacity                      = var.capacity
  auto_inflate_enabled          = var.auto_inflate_enabled
  dedicated_cluster_id          = try(azurerm_eventhub_cluster.this["this"].id, null)
  maximum_throughput_units      = var.maximum_throughput_units
  local_authentication_enabled  = var.local_authentication_enabled
  public_network_access_enabled = var.public_network_access_enabled
  minimum_tls_version           = var.minimum_tls_version
  tags                          = var.tags

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_rulesets" {
    for_each = var.network_rulesets != null ? [var.network_rulesets] : []

    content {
      default_action                 = network_rulesets.value.default_action
      public_network_access_enabled  = network_rulesets.value.public_network_access_enabled
      trusted_service_access_enabled = network_rulesets.value.trusted_service_access_enabled

      dynamic "virtual_network_rule" {
        for_each = network_rulesets.value.virtual_network_rule != null ? network_rulesets.value.virtual_network_rule : []

        content {
          subnet_id                                       = virtual_network_rule.value.subnet_id
          ignore_missing_virtual_network_service_endpoint = virtual_network_rule.value.ignore_missing_virtual_network_service_endpoint
        }
      }

      dynamic "ip_rule" {
        for_each = network_rulesets.value.ip_rule != null ? [network_rulesets.value.ip_rule] : []

        content {
          ip_mask = ip_rule.value.ip_mask
          action  = ip_rule.value.action
        }
      }
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}

resource "azurerm_eventhub_namespace_authorization_rule" "this" {
  for_each = var.authorization_rule != null ? var.authorization_rule : {}

  name                = each.value.name
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = var.resource_group_name
  listen              = each.value.listen
  send                = each.value.send
  manage              = each.value.manage

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}

resource "azurerm_eventhub_namespace_schema_group" "this" {
  for_each = var.schema_group != null ? var.schema_group : {}

  name                 = each.value.name
  namespace_id         = azurerm_eventhub_namespace.this.id
  schema_compatibility = each.value.schema_compatibility
  schema_type          = each.value.schema_type

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}

resource "azurerm_eventhub_namespace_customer_managed_key" "this" {
  for_each = var.customer_managed_key != null ? var.customer_managed_key : {}

  eventhub_namespace_id             = azurerm_eventhub_namespace.this.id
  key_vault_key_ids                 = each.value.key_vault_key_ids
  infrastructure_encryption_enabled = each.value.infrastructure_encryption_enabled
  user_assigned_identity_id         = each.value.user_assigned_identity_id

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}

resource "azurerm_eventhub_namespace_disaster_recovery_config" "this" {
  for_each = var.disaster_recovery_config != null ? var.disaster_recovery_config : {}


  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  namespace_name       = azurerm_eventhub_namespace.this.name
  partner_namespace_id = each.value.partner_namespace_id

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}
