# Separate HTTPS listener resource to avoid circular dependency
resource "aws_lb_listener" "https_with_cert" {
  count             = var.domain_name != "" && var.enable_ssl ? 1 : 0
  load_balancer_arn = module.alb.alb_arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = module.route53[0].certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arn
  }

  depends_on = [module.route53]
}

# HTTP to HTTPS redirect rule (when certificate exists)
resource "aws_lb_listener_rule" "redirect_to_https" {
  count        = var.domain_name != "" && var.enable_ssl ? 1 : 0
  listener_arn = module.alb.alb_listener_arn
  priority     = 100

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS" 
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  depends_on = [aws_lb_listener.https_with_cert]
}