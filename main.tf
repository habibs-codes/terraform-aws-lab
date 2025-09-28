resource "aws_vpc" "day2_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Day2-VPC"
    Environment = "Day2-Lab"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.day2_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = { Name = "Public-Subnet" }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.day2_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "Private-Subnet" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.day2_vpc.id
  tags = { Name = "Day2-IGW" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.day2_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "Public-RT" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

