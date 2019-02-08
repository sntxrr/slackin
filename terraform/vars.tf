terraform {
  backend "remote" {
    organization = "rrxtns"

    workspaces {
      name = "slackin-dev"
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

variable "image" {
  description = "Docker image to run in the ECS cluster"
  default     = "sntxrr/slackin"
}

variable "cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}
