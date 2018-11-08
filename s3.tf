data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "lb_logs" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.lb_logs.bucket}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
    }
  }
}
### I will like my to use the consul agent to backup to S3
data "aws_iam_policy_document" "consul_backup" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.consulbackup.bucket}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
    }
  }
}

resource "aws_s3_bucket" "lb_logs" {
  acl           = "private"
  bucket        = "lb_logs"
  tags          = "${var.tags}"
  force_destroy = "false"
}

resource "aws_s3_bucket_policy" "lb_logs" {
  bucket = "${aws_s3_bucket.lb_logs.bucket}"
  policy = "${data.aws_iam_policy_document.lb_logs.json}"
}

resource "aws_s3_bucket" "consulbackup" {
  acl           = "private"
  bucket        = "consulbackup"
  tags          = "${var.tags}"
  force_destroy = "false"
}

resource "aws_s3_bucket_policy" "consul_backup" {
  bucket = "${aws_s3_bucket.consulbackup.bucket}"
  policy = "${data.aws_iam_policy_document.consul_backup.json}"
}