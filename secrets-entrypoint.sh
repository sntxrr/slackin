#!/bin/bash

# Load the secrets from SSM parameter store into the environment variables
# using https://github.com/Droplr/aws-env/
eval $(aws-env)
printenv

# Check that the environment variables have been set correctly
if [ -z "$AWS_REGION" ]; then
  echo >&2 'error: missing AWS_REGION environment variable'
  exit 1
fi

if [ -z "$BLOCKDOMAINS_SLACK_LIST" ]; then
  echo >&2 'error: missing BLOCKDOMAINS_SLACK_LIST environment variable'
  exit 1
fi

if [ -z "$CUSTOM_CSS" ]; then
  echo >&2 'error: missing CUSTOM_CSS environment variable'
  exit 1
fi

if [ -z "$GOOGLE_CAPTCHA_SECRET" ]; then
  echo >&2 'error: missing GOOGLE_CAPTCHA_SECRET environment variable'
  exit 1
fi

if [ -z "$GOOGLE_CAPTCHA_SITEKEY" ]; then
  echo >&2 'error: missing GOOGLE_CAPTCHA_SITEKEY environment variable'
  exit 1
fi

if [ -z "$INTERVAL" ]; then
  echo >&2 'error: missing INTERVAL environment variable'
  exit 1
fi

if [ -z "$PORT" ]; then
  echo >&2 'error: missing PORT environment variable'
  exit 1
fi

if [ -z "$SLACK_API_TOKEN" ]; then
  echo >&2 'error: missing SLACK_API_TOKEN environment variable'
  exit 1
fi

if [ -z "$SLACK_CHANNELS" ]; then
  echo >&2 'error: missing SLACK_CHANNELS environment variable'
  exit 1
fi

if [ -z "$SLACK_COC" ]; then
  echo >&2 'error: missing SLACK_COC environment variable'
  exit 1
fi

if [ -z "$SLACK_SUBDOMAIN" ]; then
  echo >&2 'error: missing SLACK_SUBDOMAIN environment variable'
  exit 1
fi

echo "All env vars were set correctly"
printenv

./bin/slackin --coc "$SLACK_COC" --channels "$SLACK_CHANNELS" --port $PORT --interval $INTERVAL --css $CUSTOM_CSS $SLACK_SUBDOMAIN $SLACK_API_TOKEN $GOOGLE_CAPTCHA_SECRET $GOOGLE_CAPTCHA_SITEKEY 2>&1
