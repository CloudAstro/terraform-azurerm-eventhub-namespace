variable "name" {
  type        = string
  description = <<DESCRIPTION
* `name` - (Required) Specifies the name of the EventHub Namespace resource. Changing this forces a new resource to be created.

Example:
```
name = "eh-namespace-dev"
```
DESCRIPTION
}

variable "location" {
  type        = string
  description = <<DESCRIPTION
* location - (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Example:
```
location = "germanywestcentral"
```
DESCRIPTION
}

variable "resource_group_name" {
  type        = string
  description = <<DESCRIPTION
* `resource_group_name` - (Required) The name of the resource group in which to create the namespace. Changing this forces a new resource to be created.

Example:
```
resource_group_name = "rg-eventhub-dev-germanywestcentral"
```
DESCRIPTION
}

variable "sku" {
  type        = string
  description = <<DESCRIPTION
  * `sku` - (Required) Defines which tier to use. Valid options are `Basic`, `Standard`, and `Premium`. Please note that setting this field to `Premium` will force the creation of a new resource.

Example:
```
sku = "Standard"
```
DESCRIPTION
}

variable "capacity" {
  type        = number
  default     = 1
  description = <<DESCRIPTION
* `capacity` - (Optional) Specifies the Capacity / Throughput Units for a `Standard` SKU namespace. Default capacity has a maximum of `2`, but can be increased in blocks of 2 on a committed purchase basis. Defaults to `1`.

Example:
```
capacity = 2
```
DESCRIPTION
}

variable "auto_inflate_enabled" {
  type        = bool
  default     = null
  description = <<DESCRIPTION
* `auto_inflate_enabled` - (Optional) Is Auto Inflate enabled for the EventHub Namespace?

Example:
```
auto_inflate_enabled = true
```
DESCRIPTION
}

variable "dedicated_cluster_id" {
  type        = string
  default     = null
  description = <<DESCRIPTION
* `dedicated_cluster_id` - (Optional) Specifies the ID of the EventHub Dedicated Cluster where this Namespace should created. Changing this forces a new resource to be created.

Example:
```
dedicated_cluster_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.EventHub/clusters/my-cluster"
```
DESCRIPTION
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default     = null
  description = <<DESCRIPTION
A `identity` block supports the following:
* `type` - (Required) Specifies the type of Managed Service Identity that should be configured on this Event Hub Namespace. Possible values are `SystemAssigned` or `UserAssigned`.
* `identity_ids` - (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this EventHub namespace.

~> **Note:** This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned`.

~> **Note:** Due to the limitation of the current Azure API, once an EventHub Namespace has been assigned an identity, it cannot be removed.

Example:
```
identity = {
  type         = "UserAssigned"
  identity_ids = ["/subscriptions/000/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id1"]
}
```
DESCRIPTION
}

variable "maximum_throughput_units" {
  type        = number
  default     = null
  description = <<DESCRIPTION
* `maximum_throughput_units` - (Optional) Specifies the maximum number of throughput units when Auto Inflate is Enabled. Valid values range from `1` - `40`.

Example:
```
maximum_throughput_units = 20
```
DESCRIPTION
}

variable "network_rulesets" {
  type = list(object({
    default_action                 = string
    public_network_access_enabled  = optional(bool, true)
    trusted_service_access_enabled = optional(bool)
    virtual_network_rule = optional(set(object({
      subnet_id                                       = string
      ignore_missing_virtual_network_service_endpoint = optional(bool)
    })), null)
    ip_rule = optional(list(object({
      ip_mask = string
      action  = optional(string, "Allow")
    })), [])
  }))
  default     = null
  description = <<DESCRIPTION
* A `network_rulesets` block supports the following:
  * `default_action` - (Required) The default action to take when a rule is not matched. Possible values are `Allow` and `Deny`.
  * `public_network_access_enabled` - (Optional) Is public network access enabled for the EventHub Namespace? Defaults to `true`.

  ~> **Note:** The public network access setting at the network rule sets level should be the same as it's at the namespace level.
  * `trusted_service_access_enabled` - (Optional) Whether Trusted Microsoft Services are allowed to bypass firewall.
  * A `virtual_network_rule` block supports the following:
    * `subnet_id` - (Required) The id of the subnet to match on.
    * `ignore_missing_virtual_network_service_endpoint` - (Optional) Are missing virtual network service endpoints ignored? 
  A `ip_rule` block supports the following:
    * `ip_mask` - (Required) The IP mask to match on.
    * `action` - (Optional) The action to take when the rule is matched. Possible values are `Allow`. Defaults to `Allow`.

Example:
```
network_rulesets = [
  {
    default_action                 = "Deny"
    public_network_access_enabled  = true
    trusted_service_access_enabled = true
    virtual_network_rule = [
      {
        subnet_id = "/subscriptions/0000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet1"
      }
    ]
    ip_rule = [
      {
        ip_mask = "192.168.1.0/24"
        action  = "Allow"
      }
    ]
  }
]
```
DESCRIPTION
}

variable "local_authentication_enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
* `local_authentication_enabled` - (Optional) Is SAS authentication enabled for the EventHub Namespace? Defaults to `true`.

Example:
```
local_authentication_enabled = false
```
DESCRIPTION
}

variable "minimum_tls_version" {
  type        = string
  default     = "1.2"
  description = <<DESCRIPTION
* `minimum_tls_version` - (Optional) The minimum supported TLS version for this EventHub Namespace. Valid values are: `1.0`, `1.1` and `1.2`. Defaults to `1.2`.

~> **Note:** Azure Services will require TLS 1.2+ by August 2025, please see this [announcement](https://azure.microsoft.com/en-us/updates/v2/update-retirement-tls1-0-tls1-1-versions-azure-services/) for more.

Example:
```
minimum_tls_version = "1.2"
```
DESCRIPTION
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
* `public_network_access_enabled` - (Optional) Is public network access enabled for the EventHub Namespace? Defaults to `true`.

Example:
```
public_network_access_enabled = false
```
DESCRIPTION
}
variable "tags" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
* `tags` - (Optional) A mapping of tags to assign to the resource.

Example:
```
tags = {
  "Environment" = "Production"
  "Team"        = "DataPlatform"
}
```
DESCRIPTION
}

variable "authorization_rule" {
  type = map(object({
    name   = string
    listen = optional(bool)
    send   = optional(bool)
    manage = optional(bool)
  }))
  default     = null
  description = <<DESCRIPTION
The following arguments are supported:

~> **Note:** At least one of the 3 permissions below needs to be set.
* `name` - (Required) Specifies the name of the EventHub Authorization Rule resource. Changing this forces a new resource to be created.* listen - Enable listen permission for the Event Hub Namespace Authorization Rule. Grants the rule the ability to receive messages from the Event Hub Namespace.
* `send` - (Optional) Does this Authorization Rule have permissions to Send to the Event Hub? Defaults to `false`.
* `manage` - (Optional) Does this Authorization Rule have permissions to Manage to the Event Hub? When this property is `true` - both `listen` and `send` must be too. Defaults to `false`.

Example:
```
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
```
DESCRIPTION
}

variable "schema_group" {
  type = map(object({
    name                 = string
    schema_compatibility = string
    schema_type          = string
  }))
  default     = null
  description = <<DESCRIPTION
The following arguments are supported:
* `name` - (Required) Specifies the name of this schema group. Changing this forces a new resource to be created.
* `schema_compatibility` - (Required) Specifies the compatibility of this schema group. Possible values are `None`, `Backward`, `Forward`. Changing this forces a new resource to be created.
* `schema_type` - (Required) Specifies the Type of this schema group. Possible values are `Avro`, `Unknown` and `Json`. Changing this forces a new resource to be created.

~> **Note:** When `schema_type` is specified as `Json`, `schema_compatibility` must be set to `None`.

Example:
```
schema_group = {
  my-schema-group = {
    name                 = "my-schema-group"
    schema_compatibility = "Forward"
    schema_type          = "Avro"
  }
}

DESCRIPTION
}

variable "customer_managed_key" {
  type = map(object({
    key_vault_key_ids                 = list(string)
    infrastructure_encryption_enabled = bool
    user_assigned_identity_id         = string
  }))
  default     = null
  description = <<DESCRIPTION
The following arguments are supported:
* `key_vault_key_ids` - (Required) The list of keys of Key Vault.
* `infrastructure_encryption_enabled` - (Optional) Whether to enable Infrastructure Encryption (Double Encryption). Changing this forces a new resource to be created.
* `user_assigned_identity_id` - (Optional) The ID of a User Managed Identity that will be used to access Key Vaults that contain the encryption keys.

~> **Note:** If using `user_assigned_identity_id`, ensure the User Assigned Identity is also assigned to the parent Event Hub.

~> **Note:** If using `user_assigned_identity_id`, make sure to assign the identity the appropriate permissions to access the Key Vault key. Failure to grant `Get, UnwrapKey, and WrapKey` will cause this resource to fail to apply.

Example:
```
customer_managed_key = {
  cmk = {
    key_vault_key_ids = [
      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.KeyVault/vaults/my-kv/keys/my-key"
    ]
    infrastructure_encryption_enabled = true
    user_assigned_identity_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-uai"
  }
}
DESCRIPTION
}

variable "disaster_recovery_config" {
  type = map(object({
    name                 = string
    partner_namespace_id = string
  }))
  default     = null
  description = <<DESCRIPTION
The following arguments are supported:
* `name` - (Required) Specifies the name of the Disaster Recovery Config. Changing this forces a new resource to be created.
* `partner_namespace_id` - (Required) The ID of the EventHub Namespace to replicate to.

Example:
```
disaster_recovery_config = {
    primary-recovery-site = {
      name                 = "prod-dr-alias"
      partner_namespace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.EventHub/namespaces/my-secondary-ns"
    }
  }
```
DESCRIPTION
}

variable "timeouts" {
  type = object({
    create = optional(string, "30")
    update = optional(string, "30")
    read   = optional(string, "5")
    delete = optional(string, "30")
  })
  default     = null
  description = <<DESCRIPTION
  The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:
    * `create` - (Defaults to 30 minutes) Used when creating the EventHub.
    * `update` - (Defaults to 30 minutes) Used when updating the EventHub.
    * `read` - (Defaults to 5 minutes) Used when retrieving the EventHub.
    * `delete` - (Defaults to 30 minutes) Used when deleting the EventHub.

  Example:
  ```
    timeouts = {
      create = "60"
      update = "60"
      read   = "10"
      delete = "60"
    }
  ```
  DESCRIPTION
}
