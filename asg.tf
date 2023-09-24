#ASG with Launch Template 3 public subnet 
resource "aws_autoscaling_group" "Three-tier-asg" {
  name = "Three-tier-asg"
  desired_capacity   = 1
  max_size           = 99
  min_size           = 1
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.target-alb.arn]
  vpc_zone_identifier  = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
}
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.Three-tier-asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"   
  cooldown               = "300" 
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.Three-tier-asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}