output "eventhub_namespace" {
  value       = azurerm_eventhub_namespace.this
  description = <<DESCRIPTION
  * `id` - The EventHub Namespace ID.

  The following attributes are exported only if there is an authorization rule named RootManageSharedAccessKey which is created automatically by Azure.
  * `default_primary_connection_string` - The primary connection string for the authorization rule RootManageSharedAccessKey.
  * `default_primary_connection_string_alias` - The alias of the primary connection string for the authorization rule RootManageSharedAccessKey, which is generated when disaster recovery is enabled.
  * `default_primary_key` - The primary access key for the authorization rule RootManageSharedAccessKey.
  * `default_secondary_connection_string` - The secondary connection string for the authorization rule RootManageSharedAccessKey.
  * `default_secondary_connection_string_alias` - The alias of the secondary connection string for the authorization rule RootManageSharedAccessKey, which is generated when disaster recovery is enabled.
  * `default_secondary_key` - The secondary access key for the authorization rule RootManageSharedAccessKey.

  An `identity` block exports the following:
  * `principal_id` - The Principal ID associated with this Managed Service Identity.
  * `tenant_id` - The Tenant ID associated with this Managed Service Identity.


  Example output:
  ```
  output "eventhub_namespace_id" {
    value = module.module_name.eventhub_namespace.id
  }
  ```
  DESCRIPTION
}

output "eventhub" {
  value       = azurerm_eventhub.this
  description = <<DESCRIPTION
  * `id` - The ID of the EventHub.
  * `partition_ids` - The identifiers for partitions created for Event Hubs.


  Example output:
  ```
  output "eventhub_id" {
    value = module.module_name.eventhub.id
  }
  ```
  DESCRIPTION
}

output "authorization_rule" {
  value       = azurerm_eventhub_authorization_rule.this
  description = <<DESCRIPTION
  * `id` - The EventHub ID.
  * `primary_connection_string_alias` - The alias of the Primary Connection String for the Event Hubs authorization Rule, which is generated when disaster recovery is enabled.
  * `secondary_connection_string_alias` - The alias of the Secondary Connection String for the Event Hubs Authorization Rule, which is generated when disaster recovery is enabled.
  * `primary_connection_string` - The Primary Connection String for the Event Hubs authorization Rule.
  * `primary_key` - The Primary Key for the Event Hubs authorization Rule.
  * `secondary_connection_string` - The Secondary Connection String for the Event Hubs Authorization Rule.
  * `secondary_key` - The Secondary Key for the Event Hubs Authorization Rule.


  Example output:
  ```
  output "namespace_authorization_rule_id" {
    value = module.module_name.authorization_rule.id
  }
  ```
  DESCRIPTION
}

output "eventhub_cluster" {
  value       = azurerm_eventhub_cluster.this
  description = <<DESCRIPTION
  * `id` - The EventHub Cluster ID.


  Example output:
  ```
  output "cluster_id" {
    value = module.module_name.eventhub_cluster.id
  }
  ```
  DESCRIPTION
}

output "consumer_group" {
  value       = azurerm_eventhub_consumer_group.this
  description = <<DESCRIPTION
  * `id` - The ID of the EventHub Consumer Group.


  Example output:
  ```
  output "consumer_id" {
    value = module.module_name.consumer_group.id
  }
  ```
  DESCRIPTION
}

output "namespace_authorization_rule" {
  value       = azurerm_eventhub_namespace_authorization_rule.this
  description = <<DESCRIPTION
  * `id` - The EventHub Namespace Authorization Rule ID.
  * `primary_connection_string_alias - The alias of the Primary Connection String for the Authorization Rule, which is generated when disaster recovery is enabled.
  * `secondary_connection_string_alias` - The alias of the Secondary Connection String for the Authorization Rule, which is generated when disaster recovery is enabled.
  * `primary_connection_string` - The Primary Connection String for the Authorization Rule.
  * `primary_key` - The Primary Key for the Authorization Rule.
  * `secondary_connection_string` - The Secondary Connection String for the Authorization Rule.
  * `secondary_key` - The Secondary Key for the Authorization Rule.


  Example output:
  ```
  output "namespace_authorization_rule_id" {
    value = module.module_name.namespace_authorization_rule.id
  }
  ```
  DESCRIPTION
}

output "namespace_schema_group" {
  value       = azurerm_eventhub_namespace_schema_group.this
  description = <<DESCRIPTION
  * `id` - The ID of the EventHub Namespace Schema Group.


  Example output:
  ```
  output "schema_group_id" {
    value = module.module_name.namespace_schema_group.id
  }
  ```
  DESCRIPTION
}

output "namespace_disaster_recovery_config" {
  value       = azurerm_eventhub_namespace_disaster_recovery_config.this
  description = <<DESCRIPTION
  * `id` - The EventHub Namespace Disaster Recovery Config ID.


  Example output:
  ```
  output "namespace_disaster_recovery_config_id" {
    value = module.module_name.namespace_disaster_recovery_config.id
  }
  ```
  DESCRIPTION
}