locals {
  groups = yamldecode(file("${path.module}/groups.yaml"))
  users  = yamldecode(file("${path.module}/users.yaml"))

  group_user_list = flatten([
    for group in local.groups : [
      for permission in group.permissions : {
        name = can(regex("aws", group.name)) ? "AWS_GF_Cloud${permission.division}_${permission.department}_${permission.access}" : "App_${group.name}_${permission.division}_${permission.department}_${permission.access}"
        desc =  "Group for app ${group.name} for division ${permission.division} for department ${permission.department} to grant Role ${permission.access}"
        userids = permission.userids
      }
    ]
  ])

  # Get a list of userids for each group
  user_list = { for group in local.group_user_list : group.name => group.userids }
  
  # Flatten the list of apps for each group
  app_list = flatten([
    for group in local.groups : [
      for app in group.apps : [
        for permission in group.permissions : {
          app_name   = app
          group_name = can(regex("aws", group.name)) ? "AWS_GF_Cloud${permission.division}_${permission.department}_${permission.access}" : "App_${group.name}_${permission.division}_${permission.department}_${permission.access}"
          priority   = index(group.permissions, permission) + 1
          group_id   = okta_group.app[can(regex("aws", group.name)) ?  "AWS_GF_Cloud${permission.division}_${permission.department}_${permission.access}" : "App_${group.name}_${permission.division}_${permission.department}_${permission.access}"].id
        }
      ]
    ]
  ])

  # Get a list of unique app names
  unique_app_names = tolist(distinct([for app in local.app_list : app.app_name]))

  # Get a list of unique user types
  user_types = [for user in local.users : user.user_type]
  unique_user_types = distinct(local.user_types)
}
