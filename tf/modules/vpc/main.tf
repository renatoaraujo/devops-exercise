resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "helloworld-vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidr)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = element(sort(data.aws_availability_zones.available.names), count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "helloworld-public-subnet-${count.index}"
  }
}

resource "aws_security_group" "default" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "helloworld-default-sg"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "helloworld-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "helloworld-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
