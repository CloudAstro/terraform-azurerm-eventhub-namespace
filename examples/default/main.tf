resource "azurerm_resource_group" "this" {
  name     = "azure-eventhub-rg"
  location = "germanywestcentral"
}

module "eventhub-namespace" {
  source = "../.."

  name                          = "example-eventhub-namespace"
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  sku                           = "Basic"

  eventhub = {
    app-logs = {
      name              = "app-logs"
      partition_count   = 4
      message_retention = 7
    }
  }
}
