# Cria a VPC com duas subnets públicas e duas subnets privadas
# Recurso da VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "my-vpc"
  }
}

#Recurso do Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  
}

#Recurso da subnet publica 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_blocks[0]
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet-1"
  }
}

#Recurso da subnet publica 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_blocks[1]
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-subnet-2"
  }
}

#Recurso da tabela de roteamento da sub-rede publica 1
resource "aws_route_table" "public_route_table_1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Associação de tabela de roteamento da sub-rede pública 1
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table_1.id
}

#Recurso da tabela de roteamento da sub-rede publica 2
resource "aws_route_table" "public_route_table_2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Associação de tabela de roteamento da sub-rede pública 2
resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table_2.id
}

# Recurso do Elastic IP do NAT Gateway 1
resource "aws_eip" "nat_gateway_eip_1" {
  vpc = true
}

# Recurso do NAT Gateway 1
resource "aws_nat_gateway" "my_nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

# Recurso do Elastic IP do NAT Gateway 2
resource "aws_eip" "nat_gateway_eip_2" {
  vpc = true
}

# Recurso do NAT Gateway 2
resource "aws_nat_gateway" "my_nat_gateway_2" {
  allocation_id = aws_eip.nat_gateway_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id
}

#Recurso da subnet privada 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr_blocks[0]
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1"
  }
}

#Recurso da subnet privada 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr_blocks[1]
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-2"
  }
}

# Recurso de tabela de roteamento da sub-rede privada 1
resource "aws_route_table" "private_subnet_route_table_1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # Definimos o tráfego com destino à internet para ser enviado através do NAT Gateway
    nat_gateway_id = aws_nat_gateway.my_nat_gateway_1.id
  }

}

# Associação de tabela de roteamento da sub-rede privada 1
resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_subnet_route_table_1.id
}

# Recurso de tabela de roteamento da sub-rede privada 2
resource "aws_route_table" "private_subnet_route_table_2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # Definimos o tráfego com destino à internet para ser enviado através do NAT Gateway
    nat_gateway_id = aws_nat_gateway.my_nat_gateway_2.id
  }

}

# Associação de tabela de roteamento da sub-rede privada 2
resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_subnet_route_table_2.id
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