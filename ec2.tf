resource "aws_key_pair" "forproject" {
  key_name   = "for project"
  public_key = file("~/.ssh/id_rsa.pub")
}
 
 # data source
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}
  

  resource "aws_instance""instance1" {
  ami                         = data.aws_ami.amazon-2.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.forproject.key_name
  vpc_security_group_ids      = [aws_security_group.secgroups.id]
  subnet_id                   = aws_subnet.public1.id
  associate_public_ip_address = true
tags = {
  Name = "My Public Instance1 in public subnet1"
}
  connection {
      type        = "ssh"
      user        = var.instance_username
      private_key = file(var.private_key)
      host        = aws_instance.instance1.public_ip
  }
  provisioner "remote-exec" {
      inline = [
      "sudo yum update -y" ,
      "sudo yum install -y httpd php php-mysqlnd" ,
      "sudo systemctl start httpd" ,
      "sudo systemctl enable httpd" ,
      "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2" ,
      "cd /var/www/html" ,
      " sudo wget https://wordpress.org/latest.tar.gz" ,
      "sudo tar -xzf latest.tar.gz" ,
      " sudo cp -R wordpress/* /var/www/html/" ,
      " sudo chown -R apache:apache /var/www/html/" ,
      " sudo systemctl restart httpd"
    ]
  }
  
  }