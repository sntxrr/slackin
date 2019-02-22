# We purposefully CREATE the parameters, and insert DUMMY values
# because its dangerous to check in sensitive data to git

resource "aws_ssm_parameter" "slack_coc" {
  name  = "SLACK_COC"
  type  = "String"
  value = "<your-slack-coc-url>"
}

resource "aws_ssm_parameter" "slack_channels" {
  name  = "SLACK_CHANNELS"
  type  = "String"
  value = "<your-slack-channel>"
}

resource "aws_ssm_parameter" "slack_subdomain" {
  name  = "SLACK_SUBDOMAIN"
  type  = "String"
  value = "<your-slack-subdomain>"
}

resource "aws_ssm_parameter" "slack_api_token" {
  name  = "SLACK_API_TOKEN"
  type  = "String"
  value = "<your-slack-api-key>"
}

resource "aws_ssm_parameter" "google_captcha_secret" {
  name  = "GOOGLE_CAPTCHA_SECRET"
  type  = "String"
  value = "<your-google-captcha-secret>"
}

resource "aws_ssm_parameter" "google_captcha_sitekey" {
  name  = "GOOGLE_CAPTCHA_SITEKEY"
  type  = "String"
  value = "<your-google-captcha-sitekey>"
}

resource "aws_kms_key" "parameter_store" {
  description             = "Parameter store kms master key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "parameter_store_alias" {
  name          = "alias/parameter_store_key"
  target_key_id = "${aws_kms_key.parameter_store.id}"
}
