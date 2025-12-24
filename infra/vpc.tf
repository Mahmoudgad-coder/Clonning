resource "aws_vpc" "gad_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "gadVPC"
  }
}
resource "aws_internet_gateway" "gad_igw" {
  vpc_id = aws_vpc.gad_vpc.id

  tags = {
    Name = "gad-igw"
  }
}

resource "aws_route_table" "gad_public_RT" {
  vpc_id = aws_vpc.gad_vpc.id

  tags = {
    Name = "gad_public_RT"
  }

}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.gad_public_RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gad_igw.id
}


# إنشاء Subnet داخل الـ VPC
resource "aws_subnet" "gad_subnet" {
  vpc_id                  = aws_vpc.gad_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"  # غيرها حسب الـ region

  tags = {
    Name = "gadSubnet"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.gad_subnet.id
  route_table_id = aws_route_table.gad_public_RT.id
}