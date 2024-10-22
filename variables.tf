variable "org_name" {
    description = "The name of the organization"
    type        = string
}

variable "base_url" {
    description = "The base URL for the Okta organization"
    type        = string
}

variable "client_id" {
    description = "The client ID for the Okta application"
    type        = string
}

variable "private_key" {
    description = "The path to the private key file"
    type        = string
}

variable "scopes" {
    description = "The scopes required for the Okta application"
    type        = list(string)
}

variable "domain_name" {
    description = "The domain name for the organization"
    type        = string
  
}