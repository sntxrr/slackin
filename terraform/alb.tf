resource "aws_alb" "slackin" {
  name     = "slackin"
  internal = false

  security_groups = [
    "${aws_security_group.ecs.id}",
    "${aws_security_group.alb.id}",
  ]

  subnets = [
    "${module.base_vpc.public_subnets[0]}",
    "${module.base_vpc.public_subnets[1]}",
  ]
}

resource "aws_alb_target_group" "slackin" {
  name        = "slackin"
  protocol    = "HTTP"
  port        = "3000"
  vpc_id      = "${module.base_vpc.vpc_id}"
  target_type = "ip"

  health_check {
    path = "/"
  }
}

resource "aws_alb_listener" "slackin" {
  load_balancer_arn = "${aws_alb.slackin.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.slackin.arn}"
    type             = "forward"
  }

  depends_on = ["aws_alb_target_group.slackin"]
}

output "alb_dns_name" {
  value = "${aws_alb.slackin.dns_name}"
}
