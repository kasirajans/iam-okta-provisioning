# AWS Provisioning Project

This project automates the provisioning of AWS resources and user management using Terraform and Okta. It also integrates with Google Workspace for user authentication and management.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have an Okta account with the necessary permissions to create and manage users and groups.
- You have a Google Workspace account with admin privileges.
- You have Terraform installed on your local machine.
- You have Python installed on your local machine.

## Setup

### 1. Clone the Repository

```sh
git clone https://github.com/kasirajans/iam-okta-provisioning.git
cd iam-okta-provisioning
```

### 2. Configure Okta

1. **Create an Okta Application**:
    - Log in to your Okta account.
    - Navigate to **Applications** > **Add Application**.
    - Choose **Web** and click **Next**.
    - Fill in the required details and save the application.
    - Note down the **Client ID** and **Client Secret**.

2. **Create API Token**:
    - Navigate to **Security** > **API** > **Tokens**.
    - Click **Create Token** and note down the token.

3. **Update `local.env.tfvars`**:
    - Open `local.env.tfvars` and update the following variables:
      ```tfvars
      org_name    = "your-okta-org-name"
      base_url    = "okta.com"
      client_id   = "your-client-id"
      private_key = "path/to/your/private-key.pem"
      scopes      = ["okta.users.manage", "okta.groups.manage", "okta.groups.read", "okta.apps.read", "okta.apps.manage"]
      ```

### 3. Configure Google Workspace

1. **Enable API Access**:
    - Log in to your Google Workspace admin console.
    - Navigate to **Security** > **API Controls** > **Manage API client access**.
    - Enable API access.

2. **Create Service Account**:
    - Go to the Google Cloud Console.
    - Create a new project or select an existing one.
    - Navigate to **IAM & Admin** > **Service Accounts**.
    - Create a new service account and download the JSON key file.

3. **Share Admin Directory**:
    - Share the admin directory with the service account email.

### 4. Initialize Terraform

```sh
terraform init
```

### 5. Apply Terraform Configuration

```sh
terraform apply -var-file="local.env.tfvars"
```

### 6. Generate Login URLs

```sh
python scripts/generate_urls.py --tfvars local.env.tfvars
```

## Usage

- **Provision Resources**: Run `terraform apply` to provision AWS resources and manage users.
- **Generate URLs**: Use the provided Python script to generate login URLs for users.

## Contributing

If you want to contribute to this project, please fork the repository and create a pull request.

## License

This project is licensed under the MIT License.
