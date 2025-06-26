locals {
  authorization_rule = merge([
    for key, value in var.eventhub : (
      value.authorization_rule != null ? {
        for auth_key, auth_value in value.authorization_rule :
        "${key}_${auth_key}" => {
          parent_key = key
          name       = auth_value.name
          listen     = auth_value.listen
          send       = auth_value.send
          manage     = auth_value.manage
        }
      } : null
    )
  ]...)
}

locals {
  consumer_group = merge([
    for key, value in var.eventhub : (
      value.consumer_group != null ? {
        for con_key, con_value in value.consumer_group :
        "${key}_${con_key}" => {
          parent_key    = key
          name          = con_value.name
          user_metadata = con_value.user_metadata
        }
      } : null
    )
  ]...)
}
