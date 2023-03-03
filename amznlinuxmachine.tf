######### For Create Instance ########

data "aws_ami" "amazon-linux-2" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_instance" "merf" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.pvr.key_name
  vpc_security_group_ids = [aws_security_group.micro.id]

  tags = {
    Name = "HelloWorld"
  }

  user_data = <<EOF
#!/bin/bash
sudo apt update -y &&
sudo apt install -y nginx
echo "Hello World" > /var/www/html/index.html
EOF
}


######### Creating Public Key #######

resource "aws_key_pair" "pvr" {
  key_name   = "ok-tf"
  public_key = file("${path.module}/walk.pub")
}

resource "aws_security_group" "micro" {
  name        = "kt"
  description = "Allow HTTP and SSH traffic via Terraform"

  dynamic "ingress" {
    for_each = [22, 80]
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

egress {
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]
 } 
}
