
# Output the validation result
# output "has_duplicates" {
#   value = local.has_duplicates
# }

# Output the decoded groups
# output "decoded_groups" {
#   value = local.groups
# }

# Output the app permissions
# output "app_permissions" {
#   value = local.app_permissions
# }

# Output the user passwords with usernames
output "user_passwords" {
  value = { for user in okta_user.users : user.login => {
    username = user.login
    email    = user.email
    password = user.password
  } }
  sensitive = true
}