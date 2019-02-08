terraform {
  backend "remote" {
    organization = "rrxtns"

    workspaces {
      name = "slackin-*"
    }
  }
}

variable "AWS_REGION" {
  type    = "string"
  default = "us-west-2"
}

variable "TAG_ENV" {
  default = "dev"
}

variable "ENV" {
  default = "PROD"
}

variable "CIDR_PRIVATE" {
  default = "10.0.1.0/24,10.0.2.0/24"
}

variable "CIDR_PUBLIC" {
  default = "10.0.101.0/24,10.0.102.0/24"
}
