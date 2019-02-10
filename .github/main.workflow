workflow "Terraform" {
  resolves = [
    "terraform-plan",
    "sntxrr/create-terraformrc@master",
  ]
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "sntxrr/create-terraformrc/@master" {
  uses = "sntxrr/create-terraformrc@master"
  needs = "filter-to-pr-open-synced"
  secrets = ["TF_ENV_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform"
  }
}

action "terraform-fmt" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.1.1"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform"
  }
}

action "terraform-init" {
  uses = "sntxrr/terraform-github-actions/init@master"
  needs = [
    "terraform-fmt",
    "sntxrr/create-terraformrc@master",
  ]
  secrets = [
    "GITHUB_TOKEN",
    "TF_ENV_TOKEN",
  ]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform"
  }
}

action "terraform-validate" {
  uses = "hashicorp/terraform-github-actions/validate@v0.1.1"
  needs = "terraform-init"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform"
  }
}

action "terraform-plan" {
  uses = "hashicorp/terraform-github-actions/plan@v0.1.1"
  needs = "terraform-validate"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform"
    # If you're using Terraform workspaces, set this to the workspace name.
    TF_ACTION_WORKSPACE = "rrxtns-dev"
  }
}

workflow "on pull request merge, delete the branch" {
  on = "pull_request"
  resolves = ["branch cleanup"]
}

action "branch cleanup" {
  uses = "jessfraz/branch-cleanup-action@master"
  secrets = ["GITHUB_TOKEN"]
}

action "sntxrr/create-terraformrc@master" {
  uses = "sntxrr/create-terraformrc@master"
  needs = ["filter-to-pr-open-synced"]
  secrets = [
    "GITHUB_TOKEN",
    "TF_ENV_TOKEN",
  ]
}
