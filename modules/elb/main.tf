resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.elb_security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-lb"
    }
  )
}

resource "aws_lb_target_group" "proxy" {
  name = "${var.project_name}-${var.environment}-proxy-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200"
  }

  tags = merge(
    var.tags,
    {
      name = "${var.project_name}-${var.environment}-proxy-tg"
    }
  )
}

resource "aws_lb_target_group_attachment" "proxy" {
  count            = length(var.proxy_instance_ids)
  target_group_arn = aws_lb_target_group.proxy.arn
  target_id        = var.proxy_instance_ids[count.index]
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proxy.arn
  }
}
