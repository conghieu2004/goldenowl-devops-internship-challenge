variable "domain_name" {
  description = "The main domain name (e.g., example.com)"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for the application (e.g., app, api, www)"
  type        = string
  default     = "app"
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  type        = string
}

variable "create_certificate" {
  description = "Whether to create ACM certificate"
  type        = bool
  default     = true
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}