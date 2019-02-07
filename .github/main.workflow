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
