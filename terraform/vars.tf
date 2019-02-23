variable "aws_region" {
  default = "us-west-2"
}

variable "az_count" {
  description = "Number of availability zones to cover in a given AWS region"
  default     = "2"
}

variable "count" {
  description = "Number of docker containers to run"
  default     = "2"
}

variable "cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "image" {
  description = "Docker image to run in the ECS cluster"
  default     = "sntxrr/slackin"
}

variable "invite_domain" {
  description = "Domain in which you'd like to add slackin inviter to"
  default     = "hangops.com"
}

variable "memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = "3000"
}
