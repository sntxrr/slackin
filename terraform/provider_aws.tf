provider "aws" {
  region = "${var.aws_region}"
}

data "aws_caller_identity" "current" {}

terraform {
  backend "remote" {
    organization = "sntxrr-org"

    workspaces {
      name = "slackin"
    }
  }
}
