terraform {
  required_providers {
    okta = {
      source = "okta/okta"
      version = "~> 4.11.0"
    }
  }
}
# Configure the Okta Provider
#
# NOTE: Change place holder values denoted by brackets to real values, including
# the brackets.
#
# NOTE: If environment variables are utilized for provider settings the
# corresponding variable name does not need to be set in the provider config
# block.
provider "okta" {
    org_name    = var.org_name
    base_url    = var.base_url
    client_id   = var.client_id
    private_key = file(var.private_key)
    scopes      = var.scopes
}