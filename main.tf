#################################
# Create the Consul Nodes, expecting to split them into different subnets which is why element was introduced based on count
#################################

variable "consul_instance_type" {
  default = ""
}
resource "aws_instance" "consul" {
  count         = "${var.consul_count}"
  ami           = "${var.ami_id}"
  instance_type = "${var.consul_instance_type}"
  key_name      = "${var.ssh_keyname}"
  subnet_id     = "${element(var.subnet_ids, count.index)}"
  iam_instance_profile   = "${aws_iam_instance_profile.cluster.id}"
  vpc_security_group_ids = ["${module.consul_sec.this_security_group_id}", "${module.cluster_utility.this_security_group_id}"]
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }
  tags = "${merge (var.tags_server, map ("Name", "consul-keystore-${count.index}"))}"
}

##################################
# Create the Vault Nodes, expecting to split them into different subnets which is why element was introduced based on count
##################################



resource "aws_instance" "vault" {
  count = "${var.vault_count}"
  ami = "${var.ami_id}"
  instance_type = "${var.vault_instance_type}"
  key_name = "${var.ssh_keyname}"
  subnet_id = "${element(var.subnet_ids, count.index)}"
  iam_instance_profile = "${aws_iam_instance_profile.cluster.id}"
  vpc_security_group_ids = [
    "${module.vault_sec.this_security_group_id}",
    "${module.cluster_utility.this_security_group_id}",
    "${module.consul_sec.this_security_group_id}"]

  lifecycle {
    ignore_changes = [
      "ebs_block_device"]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  tags = "${merge (var.tags_client, map ("Name", "vault-keystore-${count.index}"))}"
}