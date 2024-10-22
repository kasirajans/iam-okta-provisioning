# data "okta_app_saml" "apps" {
#   for_each = { for app in local.app_list : "${app.group_name}-${app.app_name}" => app }

#   label = each.value.app_name
# }


# resource "okta_app_group_assignments" "this" {
#   for_each = { for app in local.app_list : "${app.group_name}-${app.app_name}" => app }

#   app_id = data.okta_app_saml.apps[each.key].id
#   group {
#     id       = okta_group.this[each.value.group_name].id
#     priority = each.value.priority
#   }
# }