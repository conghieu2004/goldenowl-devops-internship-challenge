variable "project_name" {}
variable "private_subnets" { type = list(string) }
variable "ecr_image_url" {}
variable "execution_role_arn" {}
variable "target_group_arn" {}
variable "alb_listener_arn" {}
variable "vpc_id" {
  description = "VPC ID where ECS tasks will run"
  type        = string
}
variable "alb_security_group_id" {
  description = "Security group ID of the ALB"
  type        = string
}
