provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_key_pair" "generated_key" {
  key_name   = "deployer_key"
  public_key = 

}

resource "aws_security_group" "example" {
  name_prefix = "my-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "example" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "example" {
  ami             = data.aws_ami.example.id
  instance_type   = "t2.micro" 
  key_name        = aws_key_pair.generated_key.key_name
  security_groups = [aws_security_group.example.name]


  user_data = <<EOF
#!/bin/bash
  "sudo amazon-linux-extras install nginx1 -y",
    "sudo systemctl enable nginx",
    "sudo systemctl start nginx"
EOF

}


