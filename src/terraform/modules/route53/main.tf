# Data source để lấy existing hosted zone (nếu có)
data "aws_route53_zone" "main" {
  count = var.domain_name != "" ? 1 : 0
  name  = var.domain_name
}

# Tạo hosted zone mới nếu chưa có
resource "aws_route53_zone" "main" {
  count = var.domain_name != "" && length(data.aws_route53_zone.main) == 0 ? 1 : 0
  name  = var.domain_name

  tags = {
    Name    = "${var.project_name}-hosted-zone"
    Project = var.project_name
  }
}

# Lấy hosted zone (từ data source hoặc resource vừa tạo)
locals {
  zone_id = var.domain_name != "" ? (
    length(data.aws_route53_zone.main) > 0 ? 
    data.aws_route53_zone.main[0].zone_id : 
    aws_route53_zone.main[0].zone_id
  ) : null
  
  full_domain_name = var.domain_name != "" ? "${var.subdomain}.${var.domain_name}" : null
}

# ACM Certificate cho HTTPS
resource "aws_acm_certificate" "main" {
  count           = var.create_certificate && var.domain_name != "" ? 1 : 0
  domain_name     = local.full_domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",
    var.domain_name
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "${var.project_name}-certificate"
    Project = var.project_name
  }
}

# DNS validation records cho ACM certificate
resource "aws_route53_record" "cert_validation" {
  for_each = var.create_certificate && var.domain_name != "" ? {
    for dvo in aws_acm_certificate.main[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60

  allow_overwrite = true
}

# Certificate validation
resource "aws_acm_certificate_validation" "main" {
  count           = var.create_certificate && var.domain_name != "" ? 1 : 0
  certificate_arn = aws_acm_certificate.main[0].arn
  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation : record.fqdn
  ]

  timeouts {
    create = "5m"
  }
}

# A record pointing to ALB
resource "aws_route53_record" "main" {
  count   = var.domain_name != "" ? 1 : 0
  zone_id = local.zone_id
  name    = local.full_domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id               = var.alb_zone_id
    evaluate_target_health = true
  }
}

# CNAME record for www subdomain (optional)
resource "aws_route53_record" "www" {
  count   = var.domain_name != "" ? 1 : 0
  zone_id = local.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [local.full_domain_name]
}