variable "eventhub" {
  type = map(object({
    name              = string
    partition_count   = number
    message_retention = number
    status            = optional(string, "Active")
    capture_description = optional(object({
      enabled             = bool
      encoding            = string
      interval_in_seconds = optional(number, 300)
      size_limit_in_bytes = optional(number, 314572800)
      skip_empty_archives = optional(bool, false)
      destination = object({
        name                = string
        archive_name_format = string
        blob_container_name = string
        storage_account_id  = string
      })
    }))
    authorization_rule = optional(map(object({
      name   = string
      listen = optional(bool)
      send   = optional(bool)
      manage = optional(bool)
    })))
    cluster = optional(object({
      name     = string
      sku_name = string
      tags     = optional(map(string))
    }))
    consumer_group = optional(map(object({
      name          = string
      user_metadata = optional(string)
    })))
  }))
  default     = null
  description = <<DESCRIPTION
The following arguments are supported:
* `name` - (Required) Specifies the name of the EventHub resource. Changing this forces a new resource to be created.
* `partition_count` - (Required) Specifies the current number of shards on the Event Hub.

~> **Note:** `partition_count` cannot be changed unless Eventhub Namespace SKU is `Premium` and cannot be decreased.

~> **Note:** When using a dedicated Event Hubs cluster, maximum value of `partition_count` is 1024. When using a shared parent EventHub Namespace, maximum value is 32.

* `message_retention` - (Required) Specifies the number of days to retain the events for this Event Hub.

~> **Note:** When using a dedicated Event Hubs cluster, maximum value of `message_retention` is 90 days. When using a shared parent EventHub Namespace, maximum value is 7 days; or 1 day when using a Basic SKU for the shared parent EventHub Namespace.
* A `capture_description` block supports the following:
  * `enabled` - (Required) Specifies if the Capture Description is Enabled.
  * `encoding` - (Required) Specifies the Encoding used for the Capture Description. Possible values are `Avro` and `AvroDeflate`.
  * `interval_in_seconds` - (Optional) Specifies the time interval in seconds at which the capture will happen. Values can be between `60` and `900` seconds. Defaults to `300` seconds.
  * `size_limit_in_bytes` - (Optional) Specifies the amount of data built up in your EventHub before a Capture Operation occurs. Value should be between `10485760` and `524288000` bytes. Defaults to `314572800` bytes.
  * `skip_empty_archives` - (Optional) Specifies if empty files should not be emitted if no events occur during the Capture time window. Defaults to `false`.
  * A `destination` block supports the following:
    * `name` - (Required) The Name of the Destination where the capture should take place. At this time the only supported value is `EventHubArchive.AzureBlockBlob`.
    -> **Note:** At this time it's only possible to Capture EventHub messages to Blob Storage. There's [a Feature Request for the Azure SDK to add support for Capturing messages to Azure Data Lake here](https://github.com/Azure/azure-rest-api-specs/issues/2255).
    * `archive_name_format` - (Required) The Blob naming convention for archiving. e.g. `{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}`. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order
    * `blob_container_name` - (Required) The name of the Container within the Blob Storage Account where messages should be archived.
    * `storage_account_id` - (Required) The ID of the Blob Storage Account where messages should be archived.
* `status` - (Optional) Specifies the status of the Event Hub resource. Possible values are `Active`, `Disabled` and `SendDisabled`. Defaults to `Active`.
* authorization_rule - (Optional) The following arguments are supported:
  * `name` - (Required) Specifies the name of the EventHub Authorization Rule resource. Changing this forces a new resource to be created.

  ~> **Note:** At least one of the 3 permissions below needs to be set.
  * `listen` - (Optional) Does this Authorization Rule have permissions to Listen to the Event Hub? Defaults to `false`.
  * `send` - (Optional) Does this Authorization Rule have permissions to Send to the Event Hub? Defaults to `false`.
  * `manage` - (Optional) Does this Authorization Rule have permissions to Manage to the Event Hub? When this property is `true` - both `listen` and `send` must be too. Defaults to `false`.
* `cluster`` - (Optional) The following arguments are supported:
  * `name` - (Required) Specifies the name of the EventHub Cluster resource. Changing this forces a new resource to be created.
  * `sku_name` - (Required) The SKU name of the EventHub Cluster. The only supported value at this time is `Dedicated_1`.
  * `tags` - (Optional) A mapping of tags to assign to the resource.
* `consumer_group` - (Optional) The following arguments are supported:
  * `name` - (Required) Specifies the name of the EventHub Consumer Group resource. Changing this forces a new resource to be created.
  * `user_metadata` - (Optional) Specifies the user metadata.

Example:
```
eventhub = {
    app-logs = {
      name              = "app-logs"
      partition_count   = 4
      message_retention = 7
      status            = "Active"

      capture_description = {
        enabled             = true
        encoding            = "Avro"
        interval_in_seconds = 300
        size_limit_in_bytes = 314572800
        skip_empty_archives = false
        destination = {
          name                = "EventHubArchive"
          archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
          blob_container_name = "eventhub-capture"
          storage_account_id  = "/subscriptions/…/storageAccounts/myaccount"
        }
      }

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
```
DESCRIPTION
}