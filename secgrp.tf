
module "vault_sec" {
  source      = "github.com/terraform-aws-modules/terraform-aws-security-group?ref=v1.13.0"
  name        = "vaultnodes"
  description = "Allows vault traffic"
  #I would rather not open vault traffic to the whole world but allow access from the loadbalancer
  egress_with_cidr_blocks = [
    {
      cidr_blocks = "${var.vpc_cidr_block}"
      description = "outbound"
      from_port   = 8200
      to_port     = 8200
      protocol    = "tcp"
    },
  ]

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = "${var.vpc_cidr_block}"
      description = "inbound"
      from_port   = 8200
      to_port     = 8200
      protocol    = "tcp"
    },
  ]

  egress_with_self = [
    {
      description = "Serf LAN"
      from_port   = 8201
      to_port     = 8201
      protocol    = "tcp"
    },
  ]

  ingress_with_self = [
    {
      description = "Serf LAN"
      from_port   = 8201
      to_port     = 8201
      protocol    = "tcp"
    },
  ]


  tags   = "${var.tags}"
  vpc_id = "${var.vpc_id}"
}

module "consul_sec" {
  source      = "github.com/terraform-aws-modules/terraform-aws-security-group?ref=v1.13.0"
  name        = "consulnodes"
  description = "Allows consul traffic"

  egress_with_self = [
    {
      description = "RPC"
      from_port   = 8300
      to_port     = 8300
      protocol    = "tcp"
    },
  ]

  ingress_with_self = [
    {
      description = "RPC"
      from_port   = 8300
      to_port     = 8300
      protocol    = "tcp"
    },
  ]

  egress_with_self = [
    {
      description = "Serf LAN"
      from_port   = 8301
      to_port     = 8301
      protocol    = "tcp"
    },
  ]

  ingress_with_self = [
    {
      description = "Serf LAN"
      from_port   = 8301
      to_port     = 8301
      protocol    = "tcp"
    },
  ]

  egress_with_self = [
    {
      description = "Serf LAN UDP"
      from_port   = 8301
      to_port     = 8301
      protocol    = "udp"
    },
  ]

  ingress_with_self = [
    {
      description = "Serf LAN UDP"
      from_port   = 8301
      to_port     = 8301
      protocol    = "udp"
    },
  ]

  egress_with_self = [
    {
      description = "Serf WAN"
      from_port   = 8302
      to_port     = 8302
      protocol    = "tcp"
    },
  ]

  ingress_with_self = [
    {
      description = "Serf WAN"
      from_port   = 8302
      to_port     = 8302
      protocol    = "tcp"
    },
  ]

  egress_with_self = [
    {
      description = "Serf WAN UDP"
      from_port   = 8302
      to_port     = 8302
      protocol    = "udp"
    },
  ]

  ingress_with_self = [
    {
      description = "Serf WAN UDP"
      from_port   = 8302
      to_port     = 8302
      protocol    = "udp"
    },
  ]

  egress_with_self = [
    {
      description = "HTTP API"
      from_port   = 8500
      to_port     = 8500
      protocol    = "tcp"
    },
  ]

  ingress_with_self = [
    {
      description = "HTTP API"
      from_port   = 8500
      to_port     = 8500
      protocol    = "tcp"
    },
  ]

  egress_with_self = [
    {
      description = "DNS"
      from_port   = 8600
      to_port     = 8600
      protocol    = "tcp"
    },
  ]

  ingress_with_self = [
    {
      description = "DNS"
      from_port   = 8600
      to_port     = 8600
      protocol    = "tcp"
    },
  ]

  egress_with_self = [
    {
      description = "DNS UDP"
      from_port   = 8600
      to_port     = 8600
      protocol    = "udp"
    },
  ]

  ingress_with_self = [
    {
      description = "DNS UDP"
      from_port   = 8600
      to_port     = 8600
      protocol    = "udp"
    },
  ]

  tags   = "${var.tags}"
  vpc_id = "${var.vpc_id}"
}

module "vault-https" {
  source      = "github.com/terraform-aws-modules/terraform-aws-security-group?ref=v1.13.0"
  name        = "vault-https-${var.environment_prefix}"
  description = "Allows authorities to talk to vault load balancer"

  egress_with_cidr_blocks = [
    {
      cidr_blocks = "${var.vpc_cidr_block}"
      description = "outbound"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    },
  ]

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = "${var.vpc_cidr_block}"
      description = "inbound"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    },
  ]

  egress_with_cidr_blocks = [
    {
      cidr_blocks = "${var.vpc_cidr_block}"
      description = "outbound"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
    },
  ]

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = "${var.vpc_cidr_block}"
      description = "inbound"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
    },
  ]

  egress_with_cidr_blocks = [
    {
      cidr_blocks = "${var.vpc_cidr_block}"
      description = "vault traffic to vault servers"
      from_port   = 8200
      to_port     = 8200
      protocol    = "tcp"
    },
  ]

  tags   = "${var.tags}"
  vpc_id = "${var.vpc_id}"
}

module "cluster_utility" {
  source      = "github.com/terraform-aws-modules/terraform-aws-security-group?ref=v1.13.0"
  name        = "cluster-utility"
  description = "Allows a resource all ICMP traffic, to send DNS requests, syslog messages, and logstash data as well as receive ssh connections from management cidr blocks."

  egress_with_cidr_blocks = [
    {
      cidr_blocks = "0.0.0.0/0"
      description = "outbound"
      from_port   = -1
      to_port     = -1
      protocol    = "all"
    },
  ]

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = "${var.allowed_incoming_ssh_cidrs}"
      description = "ssh"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
    },
    {
      cidr_blocks = "0.0.0.0/0"
      description = "icmp"
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
    },
    {
      cidr_blocks = "0.0.0.0/0"
      description = "icmp"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    },
  ]

  tags   = "${var.tags}"
  vpc_id = "${var.vpc_id}"
}