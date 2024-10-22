import json
import os
import subprocess
import argparse
from dotenv import dotenv_values

# Parse command-line arguments
parser = argparse.ArgumentParser(description="Generate login URLs from Terraform output")
parser.add_argument("--tfvars", required=True, help="Path to the .tfvars file")
args = parser.parse_args()

# Load environment variables from the specified .tfvars file
env_vars = dotenv_values(args.tfvars)

# Get the org_name from environment variables
org_name = env_vars.get("org_name")
# Define the base URL
base_url = env_vars.get("base_url")
if not org_name:
    raise ValueError("org_name environment variable is not set")

# Run the terraform output command and capture the output
result = subprocess.run(["terraform", "output", "-json", "user_passwords"], capture_output=True, text=True)

if result.returncode != 0:
    raise RuntimeError(f"Error running terraform output: {result.stderr}")

# Parse the JSON output
user_passwords = json.loads(result.stdout)

# Construct and print the URLs
for user, credentials in user_passwords.items():
    username = credentials["username"]
    password = credentials["password"]
    url = f"https://{org_name}.{base_url}?username={username}"
    print(url)