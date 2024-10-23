locals {
  groups = yamldecode(file("${path.module}/groups.yaml"))
  users  = yamldecode(file("${path.module}/users.yaml"))
  # Function to check for duplicate permission names within a group
  # validate_permissions = [
  #   for group in local.groups : {
  #     name                  = group.name
  #     duplicate_permissions = length(group.permissions) != length(distinct([for permission in group.permissions : permission.name]))
  #   }
  # ]

  # Ensure no group has duplicate permission names
  # has_duplicates = length([for group in local.validate_permissions : group if group.duplicate_permissions]) > 0

  app_permissions = flatten([
    for group in local.groups : [
      for permission in group.permissions : {
        name    = "App_${group.name}_${permission.division}_${permission.department}_${permission.access}"
        desc    = "App permission for ${group.name} - ${permission.division} - ${permission.department} - ${permission.access}"
        permission = "${group.name}_${permission.division}_${permission.department}_${permission.access}"
        userids = permission.userids
      }
    ]
  ])

  # Get a list of userids for each group
  user_list = { for group in local.app_permissions : group.name => group.userids }
  
  # Flatten the list of apps for each group
  app_list = flatten([
    for group in local.groups : [
      for app in group.apps : [
        for permission in group.permissions : {
          app_name   = app
          group_name = "App_${group.name}_${permission.division}_${permission.department}_${permission.access}"
          priority   = index(group.permissions, permission) + 1
          group_id   = okta_group.this["App_${group.name}_${permission.division}_${permission.department}_${permission.access}"].id
        }
      ]
    ]
  ])

  # Get a list of unique app names
  unique_app_names = tolist(distinct([for app in local.app_list : app.app_name]))

  # Get a list of unique user_type group
   user_types = [for user in local.users : user.user_type]
   unique_user_types = distinct(local.user_types)
}


# Custom validation to fail if there are duplicate permission names
# resource "null_resource" "validate_permissions" {
#   count = local.has_duplicates ? 1 : 0

#   provisioner "local-exec" {
#     command = "echo 'Error: Duplicate permission names found within groups' && exit 1"
#   }
# }
