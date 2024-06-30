#!/bin/bash
# Define environment URLs
DEV_URL="https://dev.example.com"
STAGING_URL="https://staging.example.com"
PROD_URL="https://www.example.com"

# Prompt user to select environment
echo "Select environment:"
echo "1. Development"
echo "2. Staging"
echo "3. Production"
# shellcheck disable=SC2162
read -p "Enter environment number: " ENV_NUM

# Set URL based on user input
case $ENV_NUM in
    1) ENV_URL=$DEV_URL ;;
    2) ENV_URL=$STAGING_URL ;;
    3) ENV_URL=$PROD_URL ;;
    *) echo "Invalid environment number" ;;
esac

# Replace environment URL in configuration file
#sed -i '' "s|{{BASE_URL}}|$ENV_URL|g" lib/config.dart

# Prompt user to enter app version
# shellcheck disable=SC2162
read -p "Enter app version number: " NEW_VERSION

# Replace app version in pubspec.yaml
sed -i '' "s|version:.*|version: $NEW_VERSION|g" pubspec.yaml