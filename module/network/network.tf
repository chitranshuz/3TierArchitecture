#  vpc creation
resource "aws_vpc" "main" {
    cidr_block = var.cidr
    enable_dns_hostnames = true
    enable_dns_support   = true #so that ec2 instances can get public DNS names

    tags = {
        Name = var.vpcname
    }
}

# internet gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}

# subnets creation
resource "aws_subnet" "public_sub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_sub_pub
  map_public_ip_on_launch = true

  tags = {
    Name = "public_sub"
  }
}

resource "aws_subnet" "private_sub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_sub_pri

  tags = {
    Name = "private_sub"
  }
}

resource "aws_subnet" "private_sub_t" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_sub_pri_t

  tags = {
    Name = "private_sub2"
  }
}

# public route table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.public_route.id
}

#nat gateway
resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public_sub.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

# private route table
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private_route"
  }
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.private_sub.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_route_association_t" {
  subnet_id      = aws_subnet.private_sub_t.id
  route_table_id = aws_route_table.private_route.id
}