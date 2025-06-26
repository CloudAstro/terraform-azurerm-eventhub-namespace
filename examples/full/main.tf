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
