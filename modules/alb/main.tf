resource "aws_alb" "my_alb" {
  name            = var.alb_name
  internal        = false
  load_balancer_type = var.alb_type
  subnets         = var.alb_subnets
  security_groups = var.alb_security_groups
  tags            = {
    project = "WeekendProject"
  }
  
}

resource "aws_alb_listener" "my_alb_listener_http" {
  load_balancer_arn = aws_alb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "my_alb_listener_https" {
  load_balancer_arn = aws_alb.my_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.app_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.my_alb_target_group.arn
  }
}

resource "aws_alb_target_group" "my_alb_target_group" {
  name     = "${var.alb_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

   health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 150
    timeout             = 119
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
  tags = {
    project = "WeekendProject"
  }
}

data "aws_acm_certificate" "app_cert" {
  domain   = "tasks.vincloudworks.live"
  statuses = ["ISSUED"]
}

/**resource "aws_acm_certificate" "app_cert" {
  domain_name       = "tasks.vincloudworks.live"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
} **/
