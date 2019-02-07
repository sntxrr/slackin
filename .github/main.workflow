workflow "on push to master, deploy to aws fargate" {
  on = "push"
  resolves = ["fargate deploy"]
}

action "fargate deploy" {
  uses = "jessfraz/aws-fargate-action@master"
  env = {
    AWS_REGION = "us-west-2"
    IMAGE = "sntxrr/slackin"
    PORT = "3000"
    COUNT = "2"
    CPU = "256"
    MEMORY = "512"
    BUCKET = "hangops-github-actions"
  }
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
}

workflow "on pull request merge, delete the branch" {
  on = "pull_request"
  resolves = ["branch cleanup"]
}

action "branch cleanup" {
  uses = "jessfraz/branch-cleanup-action@master"
  secrets = ["GITHUB_TOKEN"]
}
