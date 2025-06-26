resource "azurerm_eventhub" "this" {
  for_each = var.eventhub != null ? var.eventhub : {}

  name              = each.value.name
  namespace_id      = azurerm_eventhub_namespace.this.id
  partition_count   = each.value.partition_count
  message_retention = each.value.message_retention
  status            = each.value.status

  dynamic "capture_description" {
    for_each = each.value.capture_description != null ? [each.value.capture_description] : []

    content {
      enabled             = capture_description.value.enabled
      encoding            = capture_description.value.encoding
      interval_in_seconds = capture_description.value.interval_in_seconds
      size_limit_in_bytes = capture_description.value.size_limit_in_bytes
      skip_empty_archives = capture_description.value.skip_empty_archives

      dynamic "destination" {
        for_each = capture_description.value.destination != null ? [capture_description.value.destination] : []

        content {
          name                = destination.value.name
          archive_name_format = destination.value.archive_name_format
          blob_container_name = destination.value.blob_container_name
          storage_account_id  = destination.value.storage_account_id
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

resource "azurerm_eventhub_authorization_rule" "this" {
  for_each = local.authorization_rule != null ? local.authorization_rule : {}

  name                = each.value.name
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.this[each.value.parent_key].name
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

resource "azurerm_eventhub_cluster" "this" {
  for_each = var.eventhub != null ? { for key, value in var.eventhub : key => value if value.cluster != null } : {}

  name                = each.value.cluster.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = each.value.cluster.sku_name
  tags                = each.value.cluster.tags

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

resource "azurerm_eventhub_consumer_group" "this" {
  for_each = local.consumer_group != null ? local.consumer_group : {}

  name                = each.value.name
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.this[each.value.parent_key].name
  resource_group_name = var.resource_group_name
  user_metadata       = each.value.user_metadata

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
