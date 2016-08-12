provider "aws" {
  region = "${var.region}"
}

resource "aws_iam_role" "ecs_iam_role" {
  name = "${var.ecs_iam_role_name}"
  path = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": "ecs.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_iam_role_policy" {
  name = "${var.ecs_iam_role_policy_name}"
  role = "${aws_iam_role.ecs_iam_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_security_group" "elb_security_group" {
  name = "${var.elb_security_group_name}"
  description = "Allow all inbound traffic"

  ingress {
    from_port = 80
    to_port = 80
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

resource "aws_elb" "elb" {
  name = "${var.elb_name}"
  availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]

  listener {
    instance_port = "${var.container_port}"
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:${var.container_port}/health-check"
    interval = 30
  }

  security_groups = ["${aws_security_group.elb_security_group.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.task_family}"
  container_definitions = "${var.container_defintion}"
}



resource "aws_ecs_service" "ecs_service" {
  name = "${var.ecs_service_name}"
  cluster = "arn:aws:ecs:ap-southeast-2:687417341626:cluster/ecs_cluster" // TODO Remove hard coded value
  task_definition = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count = 1
  iam_role = "${aws_iam_role.ecs_iam_role.arn}"
  depends_on = ["aws_iam_role_policy.ecs_iam_role_policy"]
  deployment_maximum_percent = "100"
  deployment_minimum_healthy_percent = "0"

  load_balancer {
    elb_name = "${aws_elb.elb.name}"
    container_name = "${var.container_name}"
    container_port = "${var.container_port}"
  }
}
