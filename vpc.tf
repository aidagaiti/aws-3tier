# Creating VPC
resource "aws_vpc" "project-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "project-vpc"
  }
}

# create 1 subnet public
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.project-vpc.id
  cidr_block              = var.subnetpublic1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    name = "public_subnet1"
  }
}

# 2 subnet public
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.project-vpc.id
  cidr_block              = var.subnetpublic2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    name = "public_subnet2"
  }
}

# 3 subnet public
resource "aws_subnet" "public3" {
  vpc_id                  = aws_vpc.project-vpc.id
  cidr_block              = var.subnetpublic3_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}c"
  tags = {
    name = "public_subnet3"
  }

}


# 1 subnet private
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = var.subnetprivate1_cidr
  availability_zone = "${var.region}a"
  tags = {
    name = "private_subnet1"
  }
}

# 2 subnet private
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = var.subnetprivate2_cidr
  availability_zone = "${var.region}b"
  tags = {
    name = "private_subnet2"
  }
}

# 3 subnet private
resource "aws_subnet" "private3" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = var.subnetprivate3_cidr
  availability_zone = "${var.region}c"
  tags = {
    name = "private_subnet3"
  }
}



# Creating Internet Gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project-vpc.id

  tags = {
    name = "ProjectIGW"
  }
}


# Creating Route Table - Attach IGW to Public Subnet 
resource "aws_route_table" "public_subnet_route" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags ={
    name = "routeIGW"
  }
}

# Associating Route Table
resource "aws_route_table_association" "rt-public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_subnet_route.id
}
# Associating Route Table
resource "aws_route_table_association" "rt-public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_subnet_route.id
}

# Associating Route Table
resource "aws_route_table_association" "rt-public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public_subnet_route.id
}

# Create Elastic IP for NatGateway 
resource "aws_eip" "ipfornat" {
vpc = true 
tags = {
  name = "elastic ip for natgw"
}
}

# NAT gateway to give our private subnets to access to the outside world
resource "aws_nat_gateway" "NGW" {
  allocation_id = aws_eip.ipfornat.id
  subnet_id         = aws_subnet.public1.id
  tags = {
    name = "natgateway"
  }
}






# Creating Route Table - private routes 
resource "aws_route_table" "pr_subnet_route" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.NGW.id
  }
  
  tags ={
    name = "privateroutetable"
  }
}

# Associating Route Table
resource "aws_route_table_association" "nat-rt-private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.pr_subnet_route.id
}
# Associating Route Table
resource "aws_route_table_association" "nat-rt-private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.pr_subnet_route.id
}

# Associating Route Table
resource "aws_route_table_association" "nat-rt-private3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.pr_subnet_route.id
}

