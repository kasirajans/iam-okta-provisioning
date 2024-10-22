### Full profile:
resource "random_password" "user_password" {
  for_each = { for user in local.users : "${user.first_name}.${user.last_name}@${var.domain_name}" => user }

  length  = 16
  special = true
}

resource "okta_user" "users" {
    for_each = { for user in local.users : "${user.first_name}.${user.last_name}@${var.domain_name}" => user }
    login       = each.value.first_name
    email       = "${each.value.first_name}.${each.value.last_name}@${var.domain_name}"
    first_name  = each.value.first_name
    last_name   = each.value.last_name
    password    = random_password.user_password[each.key].result
    user_type =  each.value.user_type
}