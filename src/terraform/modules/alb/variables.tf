variable "vpc_id" {}
variable "public_subnets" { type = list(string) }
variable "project_name" {}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS"
  type        = string
  default     = ""
}
