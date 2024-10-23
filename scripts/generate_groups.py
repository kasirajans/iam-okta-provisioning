import yaml

# Load users.yaml
with open('users.yaml', 'r') as file:
    users = yaml.safe_load(file)

# Initialize a dictionary to store grouped users
grouped_users = {}

# Iterate through each user and group them
for user in users:
    key = f"App_{user['division']}_{user['departments'][0]}_{user['role']}"
    if key not in grouped_users:
        grouped_users[key] = {
            'division': user['division'],
            'department': user['departments'][0],
            'access': user['role'],
            'userids': []
        }
    grouped_users[key]['userids'].append(user['first_name'])

# Create the groups.yaml structure
groups_yaml = {
    'apps': ['AWS IAM Identity Center'],
    'permissions': list(grouped_users.values())
}

# Write the structured data to groups.yaml
with open('groups.yaml', 'w') as file:
    yaml.dump(groups_yaml, file, default_flow_style=False)

print("groups.yaml file created successfully.")