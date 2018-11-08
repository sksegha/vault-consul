###########################
# Variables
###########################

data "aws_region" current.name

variable "consul_instance_type" {
  default = "m4.large"
}

variable "vault_instance_type" {
  default = "c4.2xlarge"
}

variable "environment_prefix" {}

variable "consul_join_tag_key" {
  description = "The key of the tag to auto-join on EC2."
  default     = "consul_join"
}

variable "consul_join_tag_value" {
  description = "The value of the tag to auto-join on EC2."
  default     = "production"
}

variable "allowed_incoming_ssh_cidrs" {
  default     = []
  type        = list
  description = "If there are any ips that you want to come in other than the management vpc (like corp NAT)"
}

variable "owner" {}

variable "keystore_ami_version" {}

variable "keystore_name_pre" {}

variable "ssh_keyname" {}


variable "environment" {
  default = ""
}

variable "consul_count" {
  default = 3
}

variable "vault_count" {
  default = 2
}

variable "route53" {
  default = "gastro.io"
  type    = string
}

variable "acmcert" {
  type    = string
}
variable "vpc_cidr_block" {
  type    = string
}

variable "vpc_id" {
  type    = string
}

variable "zone_name" {}

variable "tags" {
  type    = map
  default = {
    "division"   = ""
    "department" = ""
    "data_class" = ""
    "service"    = ""
    "owner"      = ""
  }
}


variable "tags_server" {
  type    = map
  default = {
    "division"   = ""
    "department" = ""
    "data_class" = ""
    "service"    = "consul"
    "owner"      = ""
    "consul_join_tag_key" = "production"
    "consul_role" = "server"
  }
}

variable "tags_client" {
  type    = map
  default = {
    "division"   = ""
    "department" = ""
    "data_class" = ""
    "service"    = "vault"
    "owner"      = ""
    "consul_join_tag_key" = "production"
    "consul_role" = "client"
  }
}

variable "subnet_ids" {
  type = list
}

variable "ami_id" {}

variable "route53name" {
  type   = string
  default = "gastro.io"
}

