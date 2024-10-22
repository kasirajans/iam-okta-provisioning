# resource "okta_group" "this" {
#   for_each    = { for group in local.app_permissions : "App_${group.name}_${group.division}_${group.department}_${group.access}" => group }
#   name        = each.value.name
#   description = "Group for ${each.value.name}"

# }
# Assign users to groups
# resource "okta_group_memberships" "this" {
#   for_each = { for group in okta_group.this : group.name => group }

#   group_id = okta_group.this[each.key].id
#   users    = [for userid in lookup(local.user_list, each.key, []) : okta_user.users[userid].id]
# }
