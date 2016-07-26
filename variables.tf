variable "region" {
  default = "ap-southeast-2"
}

variable "image_id" {
  default = "ami-865c76e5"
}

variable "key_name" {
  default = "andrewoh1983"
}

variable "ecs_cluster_name" {
  default = "ecs_cluster"
}

variable "user_data" {
  default = "./user_data.sh"
}
