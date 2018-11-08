data "aws_region" "current" {
  current = true
}

data "aws_acm_certificate" "cluster" {
  domain   = "${var.acmcert}"
  statuses = ["ISSUED"]
}

# Create a network load balancer
resource "aws_lb" "cluster" {
  name     = "cluster"
  internal = true

  #security_groups = ["${module.vault-https.this_security_group_id}"]
  subnets = ["${var.subnet_ids}"]

  load_balancer_type         = "network"
  enable_deletion_protection = false

  tags = "${var.tags}"

  access_logs {
    bucket  = "${aws_s3_bucket.lb_logs.bucket}"
    prefix  = "cluster-${data.aws_region.current.name}"
    enabled = true
  }
}

resource "aws_lb_target_group" "cluster" {
  name     = "vault-consul"
  port     = 8200
  protocol = "TCP"

  vpc_id = "${var.vpc_id}"

  health_check {
    path                = "/v1/sys/health"
    protocol            = "HTTPS"
    interval            = "30"
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    timeout             = "10"
    matcher             = "200-399"
  }
}