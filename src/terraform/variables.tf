variable "region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "nodejs-ecs-app"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "key_name" {
  description = "d-kp-SAA-MyKeypair"
}

variable "ami_id" {
  description = "ami-0157af9aea2eef346"
}

# Route53 and SSL variables
variable "domain_name" {
  description = "Domain name for the application (e.g., example.com). Leave empty to skip Route53 setup"
  type        = string
  default     = ""
}

variable "subdomain" {
  description = "Subdomain for the application (e.g., app, api, www)"
  type        = string
  default     = "app"
}

variable "enable_ssl" {
  description = "Enable SSL certificate and HTTPS"
  type        = bool
  default     = true
}
