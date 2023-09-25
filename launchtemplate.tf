# Launch template
resource "aws_launch_template" "my_launch_template" {

  name          = "my_launch_template"
  image_id      =  data.aws_ami.amazon-2.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.forproject.id
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.secgroups.id]
  }
}