variable "region" {
  default = "ap-southeast-2"
}

variable "ecs_iam_role_name" {}

variable "ecs_iam_role_policy_name" {}

variable "elb_name" {}

variable "elb_security_group_name" {}

variable "container_port" {}

variable "container_name" {}

variable "task_family" {}

variable "container_defintion" {}

variable "ecs_service_name" {}

variable "zone_id" {}

variable "subdomain" {}
