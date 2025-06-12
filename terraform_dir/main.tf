provider "aws" {
    region = var.chosen_aws_region
    profile = "default"
  }

  resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
  }

  resource "aws_subnet" "public" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
  }

  resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
  }

  resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
  }

  resource "aws_route" "internet_access" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
  }

  resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
  }

  resource "aws_security_group" "minecraft_sg" {
  name   = "minecraft-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow Minecraft client"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH for Ansible setup"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  resource "aws_instance" "minecraft" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.minecraft_sg.id]
    key_name               = var.key_pair_name

    tags = {
      Name = "MinecraftServer"
    }

    # NOTE: In final deployment, use Ansible instead of user_data
    user_data = <<-EOF
                #!/bin/bash
                echo "Use Ansible for final setup" > /home/ubuntu/readme.txt
                EOF
  }