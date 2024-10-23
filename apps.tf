data "okta_app_saml" "apps" {
  for_each = { for app_name in local.unique_app_names : app_name => app_name }

  label = each.value
}

resource "okta_app_group_assignments" "this" {
  for_each = { for app in data.okta_app_saml.apps : app.id => app }

  app_id = each.key

  dynamic "group" {
    for_each = { for app in local.app_list : app.group_id => app if app.app_name == each.value.label }

    content {
      id       = group.value.group_id
      priority = group.value.priority
    }
  }
}