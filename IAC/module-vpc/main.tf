resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags       = merge( { Name = "${var.env}" }, var.vpc_tags )
}


resource "aws_subnet" "public_subnet" {
  count = var.subnets["public"]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets.public[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.vpc_tags , {Name = "${var.env}-public" }  )
  }


resource "aws_subnet" "web_subnet" {
  count = var.subnets["web"]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets.web[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.vpc_tags , {Name = "${var.env}-web" }  )
  }

resource "aws_subnet" "backend_subnet" {
  count = var.subnets["backend"]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets.backend[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.vpc_tags , {Name = "${var.env}-backend" }  )
  }

resource "aws_subnet" "db_subnet" {
  count = var.subnets["db"]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets.db[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.vpc_tags , {Name = "${var.env}-db" }  )
}


resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "webRT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table" "backendRT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table" "dbRT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "main" {
  domain = aws_vpc.main.id
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id = aws_subnet.public_subnet.*.id[0]
}


resource "aws_route_table_association" "pub-sub-RT" {
  count = length(var.subnets["public"])
  route_table_id = aws_route_table.publicRT.id
  subnet_id = aws_subnet.public_subnet.*.id[count.index]
}

resource "aws_route_table_association" "web-sub-RT" {
  count = length(var.subnets["web"])
  route_table_id = aws_route_table.webRT.id
  subnet_id = aws_subnet.web_subnet.*.id[count.index]
}

resource "aws_route_table_association" "backend-sub-RT" {
  count = length(var.subnets["backend"])
  route_table_id = aws_route_table.backendRT.id
  subnet_id = aws_subnet.backend_subnet.*.id[count.index]
}

resource "aws_route_table_association" "db-sub-RT" {
  count = length(var.subnets["db"])
  route_table_id = aws_route_table.dbRT.id
  subnet_id = aws_subnet.db_subnet.*.id[count.index]
}

#create vpc peering connection to workstation instance
#Add peering connection in route tables