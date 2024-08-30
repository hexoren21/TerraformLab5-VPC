resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "pub_sub1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-sub1"
  }
}

resource "aws_subnet" "pub_sub2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-sub2"
  }
}

resource "aws_subnet" "priv_sub1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "priv-sub1"
  }
}

resource "aws_subnet" "priv_sub2" {

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "eu-central-1b"
  tags = {
    Name = "priv-sub2"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my-public-rt"
  }
}

resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.pub_sub2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip1" {
  vpc = true
}

resource "aws_eip" "nat_eip2" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_eip1.id
  subnet_id     = aws_subnet.pub_sub1.id

  tags = {
    Name = "my-nat-gw-1"
  }
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_eip2.id
  subnet_id     = aws_subnet.pub_sub2.id

  tags = {
    Name = "my-nat-gw-2"
  }
}

resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }

  tags = {
    Name = "my-private-rt-1"
  }
}

resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.priv_sub1.id
  route_table_id = aws_route_table.private_rt_1.id
}



resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  }

  tags = {
    Name = "my-private-rt-2"
  }
}

resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.priv_sub2.id
  route_table_id = aws_route_table.private_rt_2.id
}

