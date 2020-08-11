resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}

# public route table that has route to ig to use with public subnet
resource "aws_route_table" "prod-public-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "prod-public"
  }
}
# private route table that does not have any route to ig. It is just able to communicate with in cluster
resource "aws_route_table" "prod-private-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "prod-private"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = var.aws_az_list[0]

  tags = {
    Name = "prod-public-subnet"
  }
}
resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.aws_az_list[0]

  tags = {
    Name = "prod-private-subnet"
  }
}

resource "aws_route_table_association" "prod-public-route-table-subnet-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.prod-public-route-table.id
}
resource "aws_route_table_association" "prod-private-route-table-subnet-association" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.prod-private-route-table.id
}

resource "aws_security_group" "allow-ssh" {
  name        = "allow_ssh_connection"
  description = "Allow ssh connection to run kops commands"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "SSH"
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

  tags = {
    Name = "allow_ssh"
  }
}