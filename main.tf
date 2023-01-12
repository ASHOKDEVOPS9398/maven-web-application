terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
  provider "aws" {
    region = "us-east-1"
  }

#Creating a Vpc

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "MYCUSTOMVPC"
  }
}

#Creating a subnet for above vpc

resource "aws_subnet" "main1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "My Custom subnet"
  }
}

#Creating a Securtiy Group

resource "aws_security_group" "mynewsg" {
  name        = "MYNEWSG"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]

  }

  ingress {
    description      = "ALLOWING WEBSERVER from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]

  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "MYNEWSG-1"
  }
}

#Creating a Internet Gateway

resource "aws_internet_gateway" "mynewigw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MYNEWCUSTOMIGW"
  }
}

#Creating a Route Table

resource "aws_route_table" "mycustomnewrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mynewigw.id
  }

  tags = {
    Name = "example"
  }
}
