variable "squid_server_ansible_file" {
  default     = "squid-server.yml"
  description = "The location of the gridserver server playbook"
}

variable "ansible_folder" {
		default = "ansible-scripts"
		description = "The location of the ansible files directory"
}

variable "squid_server_name" {
	default = "squid-server"
	description = "The Name of the gridserver Server"
}
