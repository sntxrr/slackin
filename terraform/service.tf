# there's something funny about needing to add an execution_role_arn
# adding a fake one here so things work
locals {
  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.cpu},
    "entryPoint": ["/secrets-entrypoint.sh"],
    "environment" : [
      { "name" : "AWS_REGION", "value" : "${var.aws_region}" },
      { "name" : "SLACK_COC", "valuefrom" : "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/SLACK_COC" },
      { "name" : "SLACK_CHANNELS", "valuefrom" : "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/SLACK_CHANNELS" },
      { "name" : "SLACK_SUBDOMAIN", "valuefrom" : "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/SLACK_SUBDOMAIN" },
      { "name" : "SLACK_API_TOKEN", "valuefrom" : "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/SLACK_API_TOKEN" },
      { "name" : "GOOGLE_CAPTCHA_SECRET", "valuefrom" : "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/GOOGLE_CAPTCHA_SECRET" },
      { "name" : "GOOGLE_CAPTCHA_SITEKEY", "valuefrom" : "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/GOOGLE_CAPTCHA_SITEKEY" }
    ],
    "execution_role_arn": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/app-ecs-task-execution-role",
    "image": "${var.image}",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "/fargate/service/slackin",
            "awslogs-region": "us-west-2",
            "awslogs-stream-prefix": "ecs"
        }
    },
    "memory": ${var.memory},
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.port},
        "hostPort": ${var.port}
      }
    ],
    "secrets": [
      {
        "name": "SECRET_SLACK_COC",
        "valueFrom": "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/SLACK_COC"
      },
      {
        "name": "SECRET_SLACK_CHANNELS",
        "valueFrom": "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/SLACK_CHANNELS"
      },
      {
        "name": "SECRET_SLACK_SUBDOMAIN",
        "valueFrom": "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/SLACK_SUBDOMAIN"
      },
      {
        "name": "SECRET_SLACK_API_TOKEN",
        "valueFrom": "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/SLACK_API_TOKEN"
      },
      {
        "name": "SECRET_GOOGLE_CAPTCHA_SECRET",
        "valueFrom": "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/GOOGLE_CAPTCHA_SECRET"
      },
      {
        "name": "SECRET_GOOGLE_CAPTCHA_SITEKEY",
        "valueFrom": "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/GOOGLE_CAPTCHA_SITEKEY"
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_task_definition" "app" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"

  container_definitions = "${local.container_definitions}"
  execution_role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/app-ecs-task-execution-role"
}

resource "aws_ecs_service" "main" {
  name            = "tf-ecs-service"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = ["${aws_subnet.private.*.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.app.id}"
    container_name   = "app"
    container_port   = "${var.port}"
  }

  depends_on = ["aws_alb_listener.front_end"]
}

data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "app-ecs-task-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_tasks_execution_role.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = "${aws_iam_role.ecs_tasks_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role_ssm" {
  role       = "${aws_iam_role.ecs_tasks_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/fargate/service/slackin"
  retention_in_days = "14"
}
