resource "aws_ecs_task_definition" "slackin" {
  family                = "slackin"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 256
  memory = 512
  container_definitions = "${data.template_file.slackin.rendered}"
  execution_role_arn = "${aws_iam_role.ecs_task_assume.arn}"
}

resource "aws_ecs_service" "slackin" {
  name            = "slackin"
  cluster         = "${aws_ecs_cluster.fargate.id}"
  launch_type     = "FARGATE"
  task_definition = "${aws_ecs_task_definition.slackin.arn}"
  desired_count   = 1

  network_configuration = {
    subnets = ["${module.base_vpc.private_subnets[0]}"]
    security_groups = ["${aws_security_group.ecs.id}"]
  }

  load_balancer {
   target_group_arn = "${aws_alb_target_group.slackin.arn}"
   container_name = "slackin"
   container_port = 3000
  }

  depends_on = [
    "aws_alb_listener.slackin"
  ]
}
