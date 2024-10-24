resource "okta_group" "app" {
  for_each    = { for group in local.group_user_list : group.name => group }
  name        = each.value.name
  description = "${each.value.desc}"
}

# # Assign users to groups
resource "okta_group_memberships" "this" {
  for_each = { for group in okta_group.app : group.name => group }

  group_id = okta_group.app[each.key].id
  users    = compact([for userid in lookup(local.user_list, each.key, []) : 
                contains(keys(okta_user.users), userid) ? okta_user.users[userid].id : null])
}

# # Create groups for user types Employe and Contractor
resource "okta_group" "user_type" {
  for_each = { for group_name in local.unique_user_types : group_name => group_name }
  name        = each.value
  description = "Group for ${each.value}"
}

# resource "okta_group_rule" "user_type_Employe" {
#   name   = "example"
#   status = "ACTIVE"
#   group_assignments = [
#   "<group id>"]
#   expression_type  = "urn:okta:expression:1.0"
#   expression_value = "String.startsWith(user.firstName,\"andy\")"
# }