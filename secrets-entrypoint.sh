#!/bin/bash

# Load the secrets from SSM parameter store into the environment variables
# using https://github.com/Droplr/aws-env/
eval $(aws-env)
printenv

# Check that the environment variable has been set correctly
if [ -z "$SLACK_API_TOKEN" ]; then
  echo >&2 'error: missing SLACK_API_TOKEN environment variable'
  exit 1
fi

echo "Slack coc env var is: " $SLACK_COC
echo "Slack chanels env var is: " $SLACK_CHANNELS
echo "Slack subdomain env var is: " $SLACK_SUBDOMAIN
echo "Slack API token env var is: " $SLACK_API_TOKEN
echo "Google captcha Secret env var is: " $GOOGLE_CAPTCHA_SECRET
echo "Google captcha sitekey env var is: " $GOOGLE_CAPTCHA_SITEKEY
