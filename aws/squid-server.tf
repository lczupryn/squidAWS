# Configure the AWS Provider

resource "aws_instance" "squid-server" {

    ami = "${data.aws_ami.centos7.id}"
    instance_type = "${var.aws_instance_type}"
	  subnet_id =  "${aws_default_subnet.default_az1.id}"
	  availability_zone = "${var.aws_region}a"
	  associate_public_ip_address = true

    //Clean volume on termination
    ebs_block_device {
      device_name = "/dev/sda1"
      delete_on_termination = true
    }

    tags {
	    Name = "${var.squid_server_name}"
	}

	key_name = "${var.aws_key_name}"
	security_groups = ["${aws_security_group.squid-server.id}"]

	# Wait for SSH to become availble using a simple SSH remote exec command.
	provisioner "remote-exec" {
	    inline = [
	      "ls"
	    ]

		connection {
		    type = "ssh"
		    user = "${lookup(var.user, var.platform)}"
		    private_key = "${file("${var.aws_identity_key_file}")}"
		}
	  }
}

// resource "null_resource" "squid-server_run" {
//
// 	   provisioner "local-exec" {
//       command = "ansible-playbook -vvv ${var.ansible_folder}/${var.squid_server_ansible_file} --private-key ${var.aws_identity_key_file}"
//     }
// }

resource "aws_security_group" "squid-server" {
	      name = "${var.squid_server_name}_cluster_sg"
	      description = "${var.squid_server_name} Server traffic + maintenance."
          vpc_id = "${aws_default_vpc.default.id}"

	      // These are for squid-server GUI/API's
	      ingress {
	          from_port = 8080
	          to_port = 8080
	          protocol = "tcp"
	          cidr_blocks = ["0.0.0.0/0"]
	      }
        // squid-server Messaging
        // ingress {
	      //     from_port = 8000
	      //     to_port = 8000
	      //     protocol = "tcp"
	      //     cidr_blocks = ["0.0.0.0/0"]
	      // }

	      // These are for maintenance
	      ingress {
	          from_port = 22
	          to_port = 22
	          protocol = "tcp"
	          cidr_blocks = ["0.0.0.0/0"]
	      }

	      // This is for outbound internet access
	      egress {
	          from_port = 0
	          to_port = 0
	          protocol = "-1"
	          cidr_blocks = ["0.0.0.0/0"]
	      }
}

//Adopt default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
//Adopt default subnet
resource "aws_default_subnet" "default_az1" {
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "Default subnet for ${var.aws_region}a"
  }
}
