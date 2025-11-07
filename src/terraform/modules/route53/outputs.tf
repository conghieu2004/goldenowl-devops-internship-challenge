output "zone_id" {
  description = "Route53 hosted zone ID"
  value       = local.zone_id
}

output "domain_name" {
  description = "Full domain name for the application"
  value       = local.full_domain_name
}

output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = var.create_certificate && var.domain_name != "" ? aws_acm_certificate.main[0].arn : null
}

output "certificate_domain_validation_options" {
  description = "Certificate domain validation options"
  value       = var.create_certificate && var.domain_name != "" ? aws_acm_certificate.main[0].domain_validation_options : []
}

output "nameservers" {
  description = "Name servers for the hosted zone"
  value = var.domain_name != "" ? (
    length(data.aws_route53_zone.main) > 0 ? 
    data.aws_route53_zone.main[0].name_servers : 
    aws_route53_zone.main[0].name_servers
  ) : []
}

output "hosted_zone_created" {
  description = "Whether a new hosted zone was created"
  value       = var.domain_name != "" && length(data.aws_route53_zone.main) == 0
}