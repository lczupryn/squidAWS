#####  Original Variables script from Consul example on Github.
#####  Updated as new AMI's are used etc.

provider "aws" {
   region     = "${var.aws_region}"
}

variable "platform" {
  default     = "rhel7"
  description = "The OS Platform"
}

variable "user" {
  default = {
    ubuntu  = "ubuntu"
    rhel6   = "ec2-user"
    centos6 = "centos"
    centos7 = "centos"
    rhel7   = "ec2-user"
  }
}

data "aws_ami" "centos7" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

variable "aws_region" {
  default     = "us-east-1"
  description = "The region of AWS, for AMI lookups."
}

variable "aws_instance_type" {
  default     = "t2.medium"
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "aws_identity_key_file" {
     type = "string"
}

variable  "aws_key_name" {
	 type = "string"
}
