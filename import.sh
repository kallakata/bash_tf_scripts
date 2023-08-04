#!/bin/bash

set -e

# Import resources
while read -r resource_address; do
  resource_type_and_name=$(echo "$resource_address" | awk '{print $1}')  # Extract the resource type and name
  resource_id=$(echo "$resource_address" | awk '{print $2}')            # Extract the resource ID

  # Check if the resource is already managed by Terraform
  if terraform state show "$resource_type_and_name" &>/dev/null; then
    echo "Resource $resource_type_and_name is already managed by Terraform. Skipping import."
  else
    # Import the resource into Terraform state
    terraform import "$resource_type_and_name" "$resource_id" > /dev/null 2>&1
    echo "Resource $resource_type_and_name successfully migrated."
  fi
done < resource_addresses.txt