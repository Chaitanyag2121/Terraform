terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}

provider "aws" {
    region: "ap-south-1"
    access_key = "",
    secret_key = ""
}


resource "tls_private_key" "rsa_4096" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

variable "key_name" {}

resource "aws_key_pair" "key_pair" {
    key_name   = var.key_name
    public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
    content = tls_private_key.rsa_4096.private_key_pem
    fiename = var.key_name
}

resource "aws_instance" "public_instance" {
    ami         = "ami"
    instance_type = "t2.micro"
    key_name = aws_key_pair.key_pair.key_name

    tags = {
        Name = "public_instance"
    }
}