#create external load balancer type alb with target group 
resource "aws_lb" "external-alb" {
  name               = "external-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.secgroups.id]
  subnets            = [aws_subnet.public1.id ,aws_subnet.public2.id , aws_subnet.public3.id ]
  enable_deletion_protection = true
}

# create load balancer target group
resource "aws_lb_target_group" "target-alb" {
  name     = "target-alb"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.project-vpc.id
  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    port                = 80
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}



resource "aws_lb_listener" "external-alb-listener" {
  load_balancer_arn = aws_lb.external-alb.arn
  port              = "80"
  protocol          = "HTTP"
default_action {
  type             = "forward"
  target_group_arn = aws_lb_target_group.target-alb.arn
}
}

# Target group attachment
resource "aws_lb_target_group_attachment" "tg-attachment" {
  target_group_arn = aws_lb_target_group.target-alb.arn
  target_id        = aws_instance.instance1.id
  port             = 80
}

# create a file system
resource "aws_efs_file_system" "efs" {
  creation_token = "my-efs"

  tags = {
    Name = "efs"
  }
}

resource "aws_efs_mount_target" "mount-project" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id    = aws_subnet.public1.id
}