variable "ansible_folder" {
		default = "ansible-scripts"
		description = "The location of the ansible files directory"
}

variable "region" {
		default = "us-east-1"
}

variable "platform" {
    default="centos7"
}

module "squid-server" {
  source  = "aws/"
  aws_identity_key_file = "~/Documents/PRIV/AWS/MyNorthVirginiaKeyPair.pem"
  aws_key_name = "MyNorthVirginiaKeyPair"
  squid_server_name = "squid-server"
  aws_instance_type="t2.nano"
  aws_region="${var.region}"
  platform="${var.platform}"
}
