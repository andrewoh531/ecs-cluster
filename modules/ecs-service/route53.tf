resource "aws_route53_record" "authenticator_a_record" {
  zone_id = "${var.zone_id}"
  name = "${var.subdomain}"
  type = "A"

  alias {
    name = "${aws_elb.elb.dns_name}"
    zone_id = "${aws_elb.elb.zone_id}"
    evaluate_target_health = true
  }
}
