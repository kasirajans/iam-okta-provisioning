resource "okta_group" "app" {
  for_each    = { for group in local.app_permissions : group.name => group }
  name        = each.value.name
  description = "Group for ${each.value.name}"
}

# Assign users to groups
resource "okta_group_memberships" "this" {
  for_each = { for group in okta_group.app : group.name => group }

  group_id = okta_group.app[each.key].id
  users    = compact([for userid in lookup(local.user_list, each.key, []) : 
                contains(keys(okta_user.users), userid) ? okta_user.users[userid].id : null])
}

resource "okta_group" "user_type" {
  for_each = { for group_name in local.unique_user_types : group_name => group_name }
  name        = each.value
  description = "Group for ${each.value}"
}

# resource "okta_group_rule" "example" {
#   name   = "example"
#   status = "ACTIVE"
#   group_assignments = [
#   "<group id>"]
#   expression_type  = "urn:okta:expression:1.0"
#   expression_value = "String.startsWith(user.firstName,\"andy\")"
# }