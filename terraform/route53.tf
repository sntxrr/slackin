# add some Route53 magic
resource "aws_route53_zone" "slackin" {
  name = "${var.invite_domain}"
}

resource "aws_route53_record" "alias_route53_record" {
  zone_id = "${aws_route53_zone.slackin.zone_id}"
  name    = "invite.${var.invite_domain}"
  type    = "A"

  alias {
    name                   = "${aws_alb.main.dns_name}"
    zone_id                = "${aws_alb.main.zone_id}"
    evaluate_target_health = true
  }
}
