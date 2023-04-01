# Cria a VPC com duas subnets públicas e duas subnets privadas
provider "aws" {
  profile = "sauloramos-kxc"
  region     = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_blocks[0]
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_blocks[1]
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr_blocks[0]
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr_blocks[1]
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-2"
  }
}

output "my_vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
}