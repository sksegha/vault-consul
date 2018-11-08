resource "aws_route53_zone" "cluster" {
  name    = "${var.route53name}"
  comment = "This is the Private Zone for the external keystore servers"
  vpc_id  = "${var.vpc_id}"
}

resource "aws_route53_record" "vault_lb" {
  zone_id = "${aws_route53_zone.cluster.zone_id}"
  name = "vault-keystore"
  type = "A"

  alias {
    name                   = "${aws_lb.cluster.dns_name}"
    zone_id                = "${aws_lb.cluster.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "vault" {
  count   = "${var.vault_count}"
  zone_id = "${aws_route53_zone.cluster.zone_id}"
  name    = "vault-keystore-${count.index}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.vault.*.private_ip, count.index)}"]
}

resource "aws_route53_record" "consul" {
  count   = "${var.consul_count}"
  zone_id = "${aws_route53_zone.cluster.zone_id}"
  name    = "consul-keystore-${count.index}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.consul.*.private_ip, count.index)}"]
}