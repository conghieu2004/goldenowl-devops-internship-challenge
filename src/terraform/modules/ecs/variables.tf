variable "project_name" {}
variable "private_subnets" { type = list(string) }
variable "ecr_image_url" {}
variable "execution_role_arn" {}
variable "target_group_arn" {}
variable "alb_listener_arn" {}
