resource "aws_vpc" "gateway-net" {
  cidr_block           = var.client_net
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.default_labels, { type = "network" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.gateway-net.id

  tags = merge(local.default_labels, {
    type = "igw"
  })
}

resource "aws_route_table" "gateway_rt" {
  vpc_id = aws_vpc.gateway-net.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.default_labels, {
    type = "gateway-route-table"
  })
}

resource "aws_route_table_association" "gateway_rta" {
  subnet_id      = aws_subnet.gateway-subnet.id
  route_table_id = aws_route_table.gateway_rt.id
}

resource "aws_subnet" "gateway-subnet" {
  vpc_id                  = aws_vpc.gateway-net.id
  availability_zone       = var.aws.zone
  cidr_block              = var.client_subnet
  map_public_ip_on_launch = true

  tags = merge(local.default_labels, {
    type = "subnet"
  })
}