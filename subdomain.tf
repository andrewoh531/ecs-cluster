resource "aws_route53_zone" "dev_subdomain" {
  name = "dev.andrewoh.ninja"
}

resource "aws_route53_record" "dev-ns" {
    zone_id = "${aws_route53_zone.dev_subdomain.zone_id}"
    name = "dev.andrewoh.ninja"
    type = "NS"
    ttl = "30"
    records = [
        "${aws_route53_zone.dev_subdomain.name_servers.0}",
        "${aws_route53_zone.dev_subdomain.name_servers.1}",
        "${aws_route53_zone.dev_subdomain.name_servers.2}",
        "${aws_route53_zone.dev_subdomain.name_servers.3}"
    ]
}
