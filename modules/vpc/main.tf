# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = { Name = "tf-vpc" }
}

# -----------------------------
# Public Subnet
# -----------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = { Name = "tf-public-subnet" }
}

# -----------------------------
# Private Subnet
# -----------------------------
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr

  tags = { Name = "tf-private-subnet" }
}

# -----------------------------
# Internet Gateway (for public subnet)
# -----------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "tf-igw" }
}

# -----------------------------
# Elastic IP for NAT Gateway
# -----------------------------
resource "aws_eip" "nat" {
  domain = "vpc" # allocate EIP for VPC
  tags   = { Name = "tf-nat-eip" }
}

# -----------------------------
# NAT Gateway (for private subnet)
# -----------------------------
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = { Name = "tf-nat-gw" }
}

# -----------------------------
# Route Table for Public Subnet
# -----------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "tf-public-rt" }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# -----------------------------
# Route Table for Private Subnet
# -----------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "tf-private-rt" }
}

resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

