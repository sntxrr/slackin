# add some Route53 magic
resource "aws_route53_zone" "slackin" {
  name = "sntxrr.com"
}

# what else might I be missing? who knows   
resource "aws_route53_record" "alias_route53_record" {
  zone_id = "${aws_route53_zone.slackin.zone_id}"
  name    = "invite.sntxrr.com"
  type    = "A"

  alias {
    name                   = "${aws_alb.slackin.dns_name}"
    zone_id                = "${aws_alb.slackin.zone_id}"
    evaluate_target_health = true
  }
}
