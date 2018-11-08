resource "aws_iam_role" "cluster" {
  name = "bireport_instance"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
# In case i need to send cloud watch agent logs
resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  role       = "${aws_iam_role.cluster.id}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
# In case i need to post and read items from secret manager
resource "aws_iam_role_policy_attachment" "SecretsManagerReadWrite" {
  role	     = "${aws_iam_role.cluster.id}"
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
# In case i need to read some config items from paramater store, outputs can also be posted to paramater store
resource "aws_iam_role_policy_attachment" "AmazonSSMReadOnlyAccess" {
  role       = "${aws_iam_role.cluster.id}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}
#
resource "aws_iam_role_policy_attachment" "CloudWatchLogs" {
  role       = "${aws_iam_role.cluster.id}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy" "cluster" {
  name   = "bireport"
  role   = "${aws_iam_role.cluster.id}"
  policy = "${file("${path.module}/templates/policy.json")}"
}

resource "aws_iam_instance_profile" "cluster" {
  name = "vault-consul-cluster"
  role = "${aws_iam_role.cluster.name}"
}