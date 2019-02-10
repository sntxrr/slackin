resource "aws_cloudwatch_log_group" "slackin" {
  name              = "/ecs/slackin"
  retention_in_days = 60

  tags {
    Name = "slackin"
  }
}
