<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
# Azure Event Hub Terraform Module

This Terraform module provisions and manages a fully configurable Azure Event Hubs environment. It supports deploying an Event Hub Namespace, Event Hubs, authorization rules, consumer groups, disaster recovery configuration, customer-managed keys (CMKs), schema groups, and optional integration with a dedicated Event Hubs cluster. The module enables advanced features like capture configuration, network rules, managed identities, and encryption—all using flexible input variables.

# Features

	- Creates an Event Hub Namespace with support for auto-inflate, capacity, and identity configuration.
	- Supports optional dedicated Event Hub Clusters with configurable SKU and location.
	- Creates one or more Event Hubs with optional capture settings (blob storage integration).
	- Supports Managed Identity for Event Hub Namespace.
	- Adds Network Rulesets including IP and VNet filtering.
	- Configures Authorization Rules at both Event Hub and Namespace levels.
	- Creates Consumer Groups within Event Hubs.
	- Enables Schema Group creation for data validation and compatibility checks.
	- Integrates Customer-Managed Keys (CMKs) using Key Vault and identity.
	- Sets up Geo-Disaster Recovery Configuration with a partner namespace.
	- Allows definition of resource timeouts for all supported components.

# Example Usage

This example demonstrates how to provision a fully configured Azure Event Hub environment, including an Event Hub Namespace, one or more Event Hubs with capture settings, authorization rules, a consumer group, schema group, disaster recovery setup, and optional dedicated cluster integration. It showcases how to customize identity, networking, encryption, and timeouts using flexible module inputs.

```hcl
resource "azurerm_resource_group" "this" {
  name     = "my-datahub-rg"
  location = "germanywestcentral"
}

resource "azurerm_user_assigned_identity" "this" {
  location            = azurerm_resource_group.this.location
  name                = "example-user"
  resource_group_name = azurerm_resource_group.this.name
}

module "eventhub-namespace" {
  source = "../.."

  name                = "example-eventhub-namespace"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
  capacity            = 1

  identity = {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  authorization_rule = {
    rule-1 = {
      name   = "namespace-access-policy"
      listen = true
      send   = false
      manage = false
    }
    rule-2 = {
      name   = "namespace-full-access"
      listen = true
      send   = true
      manage = true
    }
  }

  schema_group = {
    my-schema-group = {
      name                 = "my-schema-group"
      schema_compatibility = "Forward"
      schema_type          = "Avro"
    }
  }

  tags = {
    environment = "production"
    team        = "eventhub"
  }

  eventhub = {
    app-logs = {
      name              = "app-logs"
      partition_count   = 4
      message_retention = 7
      status            = "Active"

      authorization_rule = {
        app-logs = {
          name   = "reader"
          listen = true
          send   = false
          manage = false
        }
      }

      cluster = {
        name     = "my-eventhub-cluster"
        sku_name = "Dedicated_1"

        tags = {
          environment = "production"
          owner       = "team-xyz"
        }
      }

      consumer_group = {
        app-logs = {
          name          = "my-consumer-group"
          user_metadata = "Used by fraud detection pipeline"
        }
      }
    }
  }
}
```
<!-- markdownlint-disable MD033 -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |

<!-- markdownlint-disable MD013 -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_eventhub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_authorization_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_authorization_rule) | resource |
| [azurerm_eventhub_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_cluster) | resource |
| [azurerm_eventhub_consumer_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_consumer_group) | resource |
| [azurerm_eventhub_namespace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |
| [azurerm_eventhub_namespace_authorization_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_authorization_rule) | resource |
| [azurerm_eventhub_namespace_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_customer_managed_key) | resource |
| [azurerm_eventhub_namespace_disaster_recovery_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_disaster_recovery_config) | resource |
| [azurerm_eventhub_namespace_schema_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_schema_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | * location - (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.<br/><br/>Example:<pre>location = "germanywestcentral"</pre> | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | * `name` - (Required) Specifies the name of the EventHub Namespace resource. Changing this forces a new resource to be created.<br/><br/>Example:<pre>name = "eh-namespace-dev"</pre> | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | * `resource_group_name` - (Required) The name of the resource group in which to create the namespace. Changing this forces a new resource to be created.<br/><br/>Example:<pre>resource_group_name = "rg-eventhub-dev-germanywestcentral"</pre> | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | * `sku` - (Required) Defines which tier to use. Valid options are `Basic`, `Standard`, and `Premium`. Please note that setting this field to `Premium` will force the creation of a new resource.<br/><br/>Example:<pre>sku = "Standard"</pre> | `string` | n/a | yes |
| <a name="input_authorization_rule"></a> [authorization\_rule](#input\_authorization\_rule) | The following arguments are supported:<br/><br/>~> **Note:** At least one of the 3 permissions below needs to be set.<br/>* `name` - (Required) Specifies the name of the EventHub Authorization Rule resource. Changing this forces a new resource to be created.* listen - Enable listen permission for the Event Hub Namespace Authorization Rule. Grants the rule the ability to receive messages from the Event Hub Namespace.<br/>* `send` - (Optional) Does this Authorization Rule have permissions to Send to the Event Hub? Defaults to `false`.<br/>* `manage` - (Optional) Does this Authorization Rule have permissions to Manage to the Event Hub? When this property is `true` - both `listen` and `send` must be too. Defaults to `false`.<br/><br/>Example:<pre>authorization_rule = {<br/>  rule-1 = {<br/>    name   = "namespace-access-policy"<br/>    listen = true<br/>    send   = false<br/>    manage = false<br/>  }<br/>  rule-2 = {<br/>    name   = "namespace-full-access"<br/>    listen = true<br/>    send   = true<br/>    manage = true<br/>  }<br/>}</pre> | <pre>map(object({<br/>    name   = string<br/>    listen = optional(bool)<br/>    send   = optional(bool)<br/>    manage = optional(bool)<br/>  }))</pre> | `null` | no |
| <a name="input_auto_inflate_enabled"></a> [auto\_inflate\_enabled](#input\_auto\_inflate\_enabled) | * `auto_inflate_enabled` - (Optional) Is Auto Inflate enabled for the EventHub Namespace?<br/><br/>Example:<pre>auto_inflate_enabled = true</pre> | `bool` | `null` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | * `capacity` - (Optional) Specifies the Capacity / Throughput Units for a `Standard` SKU namespace. Default capacity has a maximum of `2`, but can be increased in blocks of 2 on a committed purchase basis. Defaults to `1`.<br/><br/>Example:<pre>capacity = 2</pre> | `number` | `1` | no |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | The following arguments are supported:<br/>* `key_vault_key_ids` - (Required) The list of keys of Key Vault.<br/>* `infrastructure_encryption_enabled` - (Optional) Whether to enable Infrastructure Encryption (Double Encryption). Changing this forces a new resource to be created.<br/>* `user_assigned_identity_id` - (Optional) The ID of a User Managed Identity that will be used to access Key Vaults that contain the encryption keys.<br/><br/>~> **Note:** If using `user_assigned_identity_id`, ensure the User Assigned Identity is also assigned to the parent Event Hub.<br/><br/>~> **Note:** If using `user_assigned_identity_id`, make sure to assign the identity the appropriate permissions to access the Key Vault key. Failure to grant `Get, UnwrapKey, and WrapKey` will cause this resource to fail to apply.<br/><br/>Example:<pre>customer_managed_key = {<br/>  cmk = {<br/>    key_vault_key_ids = [<br/>      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.KeyVault/vaults/my-kv/keys/my-key"<br/>    ]<br/>    infrastructure_encryption_enabled = true<br/>    user_assigned_identity_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-uai"<br/>  }<br/>}</pre> | <pre>map(object({<br/>    key_vault_key_ids                 = list(string)<br/>    infrastructure_encryption_enabled = bool<br/>    user_assigned_identity_id         = string<br/>  }))</pre> | `null` | no |
| <a name="input_dedicated_cluster_id"></a> [dedicated\_cluster\_id](#input\_dedicated\_cluster\_id) | * `dedicated_cluster_id` - (Optional) Specifies the ID of the EventHub Dedicated Cluster where this Namespace should created. Changing this forces a new resource to be created.<br/><br/>Example:<pre>dedicated_cluster_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.EventHub/clusters/my-cluster"</pre> | `string` | `null` | no |
| <a name="input_disaster_recovery_config"></a> [disaster\_recovery\_config](#input\_disaster\_recovery\_config) | The following arguments are supported:<br/>* `name` - (Required) Specifies the name of the Disaster Recovery Config. Changing this forces a new resource to be created.<br/>* `partner_namespace_id` - (Required) The ID of the EventHub Namespace to replicate to.<br/><br/>Example:<pre>disaster_recovery_config = {<br/>    primary-recovery-site = {<br/>      name                 = "prod-dr-alias"<br/>      partner_namespace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.EventHub/namespaces/my-secondary-ns"<br/>    }<br/>  }</pre> | <pre>map(object({<br/>    name                 = string<br/>    partner_namespace_id = string<br/>  }))</pre> | `null` | no |
| <a name="input_eventhub"></a> [eventhub](#input\_eventhub) | The following arguments are supported:<br/>* `name` - (Required) Specifies the name of the EventHub resource. Changing this forces a new resource to be created.<br/>* `partition_count` - (Required) Specifies the current number of shards on the Event Hub.<br/><br/>~> **Note:** `partition_count` cannot be changed unless Eventhub Namespace SKU is `Premium` and cannot be decreased.<br/><br/>~> **Note:** When using a dedicated Event Hubs cluster, maximum value of `partition_count` is 1024. When using a shared parent EventHub Namespace, maximum value is 32.<br/><br/>* `message_retention` - (Required) Specifies the number of days to retain the events for this Event Hub.<br/><br/>~> **Note:** When using a dedicated Event Hubs cluster, maximum value of `message_retention` is 90 days. When using a shared parent EventHub Namespace, maximum value is 7 days; or 1 day when using a Basic SKU for the shared parent EventHub Namespace.<br/>* A `capture_description` block supports the following:<br/>  * `enabled` - (Required) Specifies if the Capture Description is Enabled.<br/>  * `encoding` - (Required) Specifies the Encoding used for the Capture Description. Possible values are `Avro` and `AvroDeflate`.<br/>  * `interval_in_seconds` - (Optional) Specifies the time interval in seconds at which the capture will happen. Values can be between `60` and `900` seconds. Defaults to `300` seconds.<br/>  * `size_limit_in_bytes` - (Optional) Specifies the amount of data built up in your EventHub before a Capture Operation occurs. Value should be between `10485760` and `524288000` bytes. Defaults to `314572800` bytes.<br/>  * `skip_empty_archives` - (Optional) Specifies if empty files should not be emitted if no events occur during the Capture time window. Defaults to `false`.<br/>  * A `destination` block supports the following:<br/>    * `name` - (Required) The Name of the Destination where the capture should take place. At this time the only supported value is `EventHubArchive.AzureBlockBlob`.<br/>    -> **Note:** At this time it's only possible to Capture EventHub messages to Blob Storage. There's [a Feature Request for the Azure SDK to add support for Capturing messages to Azure Data Lake here](https://github.com/Azure/azure-rest-api-specs/issues/2255).<br/>    * `archive_name_format` - (Required) The Blob naming convention for archiving. e.g. `{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}`. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order<br/>    * `blob_container_name` - (Required) The name of the Container within the Blob Storage Account where messages should be archived.<br/>    * `storage_account_id` - (Required) The ID of the Blob Storage Account where messages should be archived.<br/>* `status` - (Optional) Specifies the status of the Event Hub resource. Possible values are `Active`, `Disabled` and `SendDisabled`. Defaults to `Active`.<br/>* authorization\_rule - (Optional) The following arguments are supported:<br/>  * `name` - (Required) Specifies the name of the EventHub Authorization Rule resource. Changing this forces a new resource to be created.<br/><br/>  ~> **Note:** At least one of the 3 permissions below needs to be set.<br/>  * `listen` - (Optional) Does this Authorization Rule have permissions to Listen to the Event Hub? Defaults to `false`.<br/>  * `send` - (Optional) Does this Authorization Rule have permissions to Send to the Event Hub? Defaults to `false`.<br/>  * `manage` - (Optional) Does this Authorization Rule have permissions to Manage to the Event Hub? When this property is `true` - both `listen` and `send` must be too. Defaults to `false`.<br/>* `cluster` - (Optional) The following arguments are supported:<br/>  * `name` - (Required) Specifies the name of the EventHub Cluster resource. Changing this forces a new resource to be created.<br/>  * `sku_name` - (Required) The SKU name of the EventHub Cluster. The only supported value at this time is `Dedicated_1`.<br/>  * `tags` - (Optional) A mapping of tags to assign to the resource.<br/>* `consumer_group` - (Optional) The following arguments are supported:<br/>  * `name` - (Required) Specifies the name of the EventHub Consumer Group resource. Changing this forces a new resource to be created.<br/>  * `user_metadata` - (Optional) Specifies the user metadata.<br/><br/>Example:<pre>eventhub = {<br/>    app-logs = {<br/>      name              = "app-logs"<br/>      partition_count   = 4<br/>      message_retention = 7<br/>      status            = "Active"<br/><br/>      capture_description = {<br/>        enabled             = true<br/>        encoding            = "Avro"<br/>        interval_in_seconds = 300<br/>        size_limit_in_bytes = 314572800<br/>        skip_empty_archives = false<br/>        destination = {<br/>          name                = "EventHubArchive"<br/>          archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"<br/>          blob_container_name = "eventhub-capture"<br/>          storage_account_id  = "/subscriptions/…/storageAccounts/myaccount"<br/>        }<br/>      }<br/><br/>      authorization_rule = {<br/>        app-logs = {<br/>          name   = "reader"<br/>          listen = true<br/>          send   = false<br/>          manage = false<br/>        }<br/>      }<br/><br/>      cluster = {<br/>        name     = "my-eventhub-cluster"<br/>        sku_name = "Dedicated_1"<br/><br/>        tags = {<br/>          environment = "production"<br/>          owner       = "team-xyz"<br/>        }<br/>      }<br/><br/>      consumer_group = {<br/>        app-logs = {<br/>          name          = "my-consumer-group"<br/>          user_metadata = "Used by fraud detection pipeline"<br/>        }<br/>      }<br/>    }<br/>  }</pre> | <pre>map(object({<br/>    name              = string<br/>    partition_count   = number<br/>    message_retention = number<br/>    status            = optional(string, "Active")<br/>    capture_description = optional(object({<br/>      enabled             = bool<br/>      encoding            = string<br/>      interval_in_seconds = optional(number, 300)<br/>      size_limit_in_bytes = optional(number, 314572800)<br/>      skip_empty_archives = optional(bool, false)<br/>      destination = object({<br/>        name                = string<br/>        archive_name_format = string<br/>        blob_container_name = string<br/>        storage_account_id  = string<br/>      })<br/>    }))<br/>    authorization_rule = optional(map(object({<br/>      name   = string<br/>      listen = optional(bool)<br/>      send   = optional(bool)<br/>      manage = optional(bool)<br/>    })))<br/>    cluster = optional(object({<br/>      name     = string<br/>      sku_name = string<br/>      tags     = optional(map(string))<br/>    }))<br/>    consumer_group = optional(map(object({<br/>      name          = string<br/>      user_metadata = optional(string)<br/>    })))<br/>  }))</pre> | `null` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | A `identity` block supports the following:<br/>* `type` - (Required) Specifies the type of Managed Service Identity that should be configured on this Event Hub Namespace. Possible values are `SystemAssigned` or `UserAssigned`.<br/>* `identity_ids` - (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this EventHub namespace.<br/><br/>~> **Note:** This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned`.<br/><br/>~> **Note:** Due to the limitation of the current Azure API, once an EventHub Namespace has been assigned an identity, it cannot be removed.<br/><br/>Example:<pre>identity = {<br/>  type         = "UserAssigned"<br/>  identity_ids = ["/subscriptions/000/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id1"]<br/>}</pre> | <pre>object({<br/>    type         = string<br/>    identity_ids = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_local_authentication_enabled"></a> [local\_authentication\_enabled](#input\_local\_authentication\_enabled) | * `local_authentication_enabled` - (Optional) Is SAS authentication enabled for the EventHub Namespace? Defaults to `true`.<br/><br/>Example:<pre>local_authentication_enabled = false</pre> | `bool` | `true` | no |
| <a name="input_maximum_throughput_units"></a> [maximum\_throughput\_units](#input\_maximum\_throughput\_units) | * `maximum_throughput_units` - (Optional) Specifies the maximum number of throughput units when Auto Inflate is Enabled. Valid values range from `1` - `40`.<br/><br/>Example:<pre>maximum_throughput_units = 20</pre> | `number` | `null` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | * `minimum_tls_version` - (Optional) The minimum supported TLS version for this EventHub Namespace. Valid values are: `1.0`, `1.1` and `1.2`. Defaults to `1.2`.<br/><br/>~> **Note:** Azure Services will require TLS 1.2+ by August 2025, please see this [announcement](https://azure.microsoft.com/en-us/updates/v2/update-retirement-tls1-0-tls1-1-versions-azure-services/) for more.<br/><br/>Example:<pre>minimum_tls_version = "1.2"</pre> | `string` | `"1.2"` | no |
| <a name="input_network_rulesets"></a> [network\_rulesets](#input\_network\_rulesets) | * A `network_rulesets` block supports the following:<br/>  * `default_action` - (Required) The default action to take when a rule is not matched. Possible values are `Allow` and `Deny`.<br/>  * `public_network_access_enabled` - (Optional) Is public network access enabled for the EventHub Namespace? Defaults to `true`.<br/><br/>  ~> **Note:** The public network access setting at the network rule sets level should be the same as it's at the namespace level.<br/>  * `trusted_service_access_enabled` - (Optional) Whether Trusted Microsoft Services are allowed to bypass firewall.<br/>  * A `virtual_network_rule` block supports the following:<br/>    * `subnet_id` - (Required) The id of the subnet to match on.<br/>    * `ignore_missing_virtual_network_service_endpoint` - (Optional) Are missing virtual network service endpoints ignored? <br/>  A `ip_rule` block supports the following:<br/>    * `ip_mask` - (Required) The IP mask to match on.<br/>    * `action` - (Optional) The action to take when the rule is matched. Possible values are `Allow`. Defaults to `Allow`.<br/><br/>Example:<pre>network_rulesets = [<br/>  {<br/>    default_action                 = "Deny"<br/>    public_network_access_enabled  = true<br/>    trusted_service_access_enabled = true<br/>    virtual_network_rule = [<br/>      {<br/>        subnet_id = "/subscriptions/0000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet1"<br/>      }<br/>    ]<br/>    ip_rule = [<br/>      {<br/>        ip_mask = "192.168.1.0/24"<br/>        action  = "Allow"<br/>      }<br/>    ]<br/>  }<br/>]</pre> | <pre>list(object({<br/>    default_action                 = string<br/>    public_network_access_enabled  = optional(bool, true)<br/>    trusted_service_access_enabled = optional(bool)<br/>    virtual_network_rule = optional(set(object({<br/>      subnet_id                                       = string<br/>      ignore_missing_virtual_network_service_endpoint = optional(bool)<br/>    })), null)<br/>    ip_rule = optional(list(object({<br/>      ip_mask = string<br/>      action  = optional(string, "Allow")<br/>    })), [])<br/>  }))</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | * `public_network_access_enabled` - (Optional) Is public network access enabled for the EventHub Namespace? Defaults to `true`.<br/><br/>Example:<pre>public_network_access_enabled = false</pre> | `bool` | `true` | no |
| <a name="input_schema_group"></a> [schema\_group](#input\_schema\_group) | The following arguments are supported:<br/>* `name` - (Required) Specifies the name of this schema group. Changing this forces a new resource to be created.<br/>* `schema_compatibility` - (Required) Specifies the compatibility of this schema group. Possible values are `None`, `Backward`, `Forward`. Changing this forces a new resource to be created.<br/>* `schema_type` - (Required) Specifies the Type of this schema group. Possible values are `Avro`, `Unknown` and `Json`. Changing this forces a new resource to be created.<br/><br/>~> **Note:** When `schema_type` is specified as `Json`, `schema_compatibility` must be set to `None`.<br/><br/>Example:<pre>schema_group = {<br/>  my-schema-group = {<br/>    name                 = "my-schema-group"<br/>    schema_compatibility = "Forward"<br/>    schema_type          = "Avro"<br/>  }<br/>}</pre> | <pre>map(object({<br/>    name                 = string<br/>    schema_compatibility = string<br/>    schema_type          = string<br/>  }))</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | * `tags` - (Optional) A mapping of tags to assign to the resource.<br/><br/>Example:<pre>tags = {<br/>  "Environment" = "Production"<br/>  "Team"        = "DataPlatform"<br/>}</pre> | `map(string)` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:<br/>    * `create` - (Defaults to 30 minutes) Used when creating the EventHub.<br/>    * `update` - (Defaults to 30 minutes) Used when updating the EventHub.<br/>    * `read` - (Defaults to 5 minutes) Used when retrieving the EventHub.<br/>    * `delete` - (Defaults to 30 minutes) Used when deleting the EventHub.<br/><br/>  Example:<pre>timeouts = {<br/>      create = "60"<br/>      update = "60"<br/>      read   = "10"<br/>      delete = "60"<br/>    }</pre> | <pre>object({<br/>    create = optional(string, "30")<br/>    update = optional(string, "30")<br/>    read   = optional(string, "5")<br/>    delete = optional(string, "30")<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_authorization_rule"></a> [authorization\_rule](#output\_authorization\_rule) | * `id` - The EventHub ID.<br/>  * `primary_connection_string_alias` - The alias of the Primary Connection String for the Event Hubs authorization Rule, which is generated when disaster recovery is enabled.<br/>  * `secondary_connection_string_alias` - The alias of the Secondary Connection String for the Event Hubs Authorization Rule, which is generated when disaster recovery is enabled.<br/>  * `primary_connection_string` - The Primary Connection String for the Event Hubs authorization Rule.<br/>  * `primary_key` - The Primary Key for the Event Hubs authorization Rule.<br/>  * `secondary_connection_string` - The Secondary Connection String for the Event Hubs Authorization Rule.<br/>  * `secondary_key` - The Secondary Key for the Event Hubs Authorization Rule.<br/><br/><br/>  Example output:<pre>output "namespace_authorization_rule_id" {<br/>    value = module.module_name.authorization_rule.id<br/>  }</pre> |
| <a name="output_consumer_group"></a> [consumer\_group](#output\_consumer\_group) | * `id` - The ID of the EventHub Consumer Group.<br/><br/><br/>  Example output:<pre>output "consumer_id" {<br/>    value = module.module_name.consumer_group.id<br/>  }</pre> |
| <a name="output_eventhub"></a> [eventhub](#output\_eventhub) | * `id` - The ID of the EventHub.<br/>  * `partition_ids` - The identifiers for partitions created for Event Hubs.<br/><br/><br/>  Example output:<pre>output "eventhub_id" {<br/>    value = module.module_name.eventhub.id<br/>  }</pre> |
| <a name="output_eventhub_cluster"></a> [eventhub\_cluster](#output\_eventhub\_cluster) | * `id` - The EventHub Cluster ID.<br/><br/><br/>  Example output:<pre>output "cluster_id" {<br/>    value = module.module_name.eventhub_cluster.id<br/>  }</pre> |
| <a name="output_eventhub_namespace"></a> [eventhub\_namespace](#output\_eventhub\_namespace) | * `id` - The EventHub Namespace ID.<br/><br/>  The following attributes are exported only if there is an authorization rule named RootManageSharedAccessKey which is created automatically by Azure.<br/>  * `default_primary_connection_string` - The primary connection string for the authorization rule RootManageSharedAccessKey.<br/>  * `default_primary_connection_string_alias` - The alias of the primary connection string for the authorization rule RootManageSharedAccessKey, which is generated when disaster recovery is enabled.<br/>  * `default_primary_key` - The primary access key for the authorization rule RootManageSharedAccessKey.<br/>  * `default_secondary_connection_string` - The secondary connection string for the authorization rule RootManageSharedAccessKey.<br/>  * `default_secondary_connection_string_alias` - The alias of the secondary connection string for the authorization rule RootManageSharedAccessKey, which is generated when disaster recovery is enabled.<br/>  * `default_secondary_key` - The secondary access key for the authorization rule RootManageSharedAccessKey.<br/><br/>  An `identity` block exports the following:<br/>  * `principal_id` - The Principal ID associated with this Managed Service Identity.<br/>  * `tenant_id` - The Tenant ID associated with this Managed Service Identity.<br/><br/><br/>  Example output:<pre>output "eventhub_namespace_id" {<br/>    value = module.module_name.eventhub_namespace.id<br/>  }</pre> |
| <a name="output_namespace_authorization_rule"></a> [namespace\_authorization\_rule](#output\_namespace\_authorization\_rule) | * `id` - The EventHub Namespace Authorization Rule ID.<br/>  * `primary_connection_string_alias - The alias of the Primary Connection String for the Authorization Rule, which is generated when disaster recovery is enabled.<br/>  * `secondary\_connection\_string\_alias` - The alias of the Secondary Connection String for the Authorization Rule, which is generated when disaster recovery is enabled.<br/>  * `primary\_connection\_string` - The Primary Connection String for the Authorization Rule.<br/>  * `primary\_key` - The Primary Key for the Authorization Rule.<br/>  * `secondary\_connection\_string` - The Secondary Connection String for the Authorization Rule.<br/>  * `secondary\_key` - The Secondary Key for the Authorization Rule.<br/><br/><br/>  Example output:<br/>  `<pre>output "namespace_authorization_rule_id" {<br/>    value = module.module_name.namespace_authorization_rule.id<br/>  }</pre> |
| <a name="output_namespace_disaster_recovery_config"></a> [namespace\_disaster\_recovery\_config](#output\_namespace\_disaster\_recovery\_config) | * `id` - The EventHub Namespace Disaster Recovery Config ID.<br/><br/><br/>  Example output:<pre>output "namespace_disaster_recovery_config_id" {<br/>    value = module.module_name.namespace_disaster_recovery_config.id<br/>  }</pre> |
| <a name="output_namespace_schema_group"></a> [namespace\_schema\_group](#output\_namespace\_schema\_group) | * `id` - The ID of the EventHub Namespace Schema Group.<br/><br/><br/>  Example output:<pre>output "schema_group_id" {<br/>    value = module.module_name.namespace_schema_group.id<br/>  }</pre> |

## Modules

No modules.

## 🙋 Support

Please open a GitHub issue or start a discussion if you encounter problems or would like to suggest improvements. Contributions are welcome!

## 🧾 License  

This module is released under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for full details.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->