provider "aws" {
  region = "${var.region}"
}

resource "aws_iam_role" "ecs_cluster_ec2_role" {
  name = "ecs_cluster_ec2_role"
  path = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  roles = ["${aws_iam_role.ecs_cluster_ec2_role.name}"]
}

resource "aws_security_group" "ecs_ec2_security_group" {
  name = "ecs_ec2_security_group"
  description = "Allow inbound traffic for ports 22, 80 and 443"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
    name_prefix = "ecs_launch_config_"
    image_id = "${var.image_id}"
    instance_type = "t2.micro"
    iam_instance_profile = "${aws_iam_instance_profile.ec2_instance_profile.id}"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.ecs_ec2_security_group.id}"]

    lifecycle {
      create_before_destroy = true
    }
}
