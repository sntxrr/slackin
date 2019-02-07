workflow "on push to master, deploy to aws fargate" {
  on = "push"
  resolves = ["fargate deploy"]
}

action "fargate deploy" {
  uses = "jessfraz/aws-fargate-action@master"
  env = {
    AWS_REGION = "us-west-2"
    IMAGE = "r.j3ss.co/party-clippy"
    PORT = "8080"
    COUNT = "2"
    CPU = "256"
    MEMORY = "512"
    BUCKET = "aws-fargate-action"
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

workflow "on push, Docker build" {
  on = "push"
  resolves = ["GitHub Action for Docker"]
}

action "GitHub Action for Docker" {
  uses = "actions/docker/cli@aea64bb1b97c42fa69b90523667fef56b90d7cff"
}
