resource "aws_route53_zone" "slackin" {
  name = "sntxrr.com"
}

resource "aws_route53_record" "alias_route53_record" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "invite.sntxrr.com"
  type    = "A"

  alias {
    name                   = "${aws_lb.slackin.dns_name}"
    zone_id                = "${aws_lb.slackin.zone_id}"
    evaluate_target_health = true
  }
}
