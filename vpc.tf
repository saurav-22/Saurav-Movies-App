# Create VPC
resource "aws_vpc" "tf-vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform VPC"
  }
}

# Create 3 Public Subnets (1 in each AZ)
resource "aws_subnet" "tf-public-subnets" {
  for_each = {
    "1a" = { cidr = "10.1.1.0/24", az = "ap-south-1a" }
    "1b" = { cidr = "10.1.2.0/24", az = "ap-south-1b" }
    "1c" = { cidr = "10.1.3.0/24", az = "ap-south-1c" }
  }
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags = {
    Name = "TF-Public-Subnet-${each.key}"
  }
}
# Create 3 Private Subnets (1 in each AZ)
resource "aws_subnet" "tf-private-subnets" {
  for_each = {
    "1a" = { cidr = "10.1.4.0/24", az = "ap-south-1a" }
    "1b" = { cidr = "10.1.5.0/24", az = "ap-south-1b" }
    "1c" = { cidr = "10.1.6.0/24", az = "ap-south-1c" }
  }
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags = {
    Name = "TF-Private-Subnet-${each.key}"
  }
}
# Create 1 Database Subnet (No NAT Gateway in this)
resource "aws_subnet" "tf-db-subnet" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "10.1.7.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "TF-DB-Subnet"
  }
}
# Create Route Table for DB Subnet
resource "aws_route_table" "tf-db-rt" {
  vpc_id = aws_vpc.tf-vpc.id
  tags = {
    Name = "TF-DB-RT"
  }
}
# DB Route Table association
resource "aws_route_table_association" "tf-db-rt-association" {
  subnet_id      = aws_subnet.tf-db-subnet.id
  route_table_id = aws_route_table.tf-db-rt.id

}

# Create Internet Gateway
resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.tf-vpc.id
  tags = {
    Name = "TF-IGW"
  }
}

# Create Public Route Table
resource "aws_route_table" "tf-public-rt" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-igw.id
  }

  tags = {
    Name = "TF-Public-RT"
  }
}

# Public Route Table association
resource "aws_route_table_association" "tf-public-rt-association" {
  for_each       = aws_subnet.tf-public-subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.tf-public-rt.id
}

# Create Elastic IP
resource "aws_eip" "tf-eip" {
  domain = "vpc"
  tags = {
    Name = "TF-EIP"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "tf-nat" {
  allocation_id = aws_eip.tf-eip.id
  subnet_id     = aws_subnet.tf-public-subnets["1a"].id

  tags = {
    Name = "TF-NAT"
  }
  depends_on = [aws_internet_gateway.tf-igw]
}

# Create Private Route Table
resource "aws_route_table" "tf-private-rt" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf-nat.id
  }

  tags = {
    Name = "TF-Private-RT"
  }
}

# Private Route Table association
resource "aws_route_table_association" "tf-private-rt-association" {
  for_each       = aws_subnet.tf-private-subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.tf-private-rt.id
}

# Create S3 Endpoint
resource "aws_vpc_endpoint" "tf-s3-endpoint" {
  vpc_id       = aws_vpc.tf-vpc.id
  service_name = "com.amazonaws.ap-south-1.s3"
}