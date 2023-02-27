terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "us-west-1"
  access_key = ""
  secret_key = ""
}
 
resource "aws_instance" "my-server" {
  ami           = "ami-00569e54da628d17c"
  instance_type = "t2.micro"
  count         = 5

  availability_zone = "us-west-1"
}

