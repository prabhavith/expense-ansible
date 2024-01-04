resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags       = merge( { Name = "${var.env}" }, var.vpc_tags )
}


resource "aws_subnet" "public_subnet" {
  count = length(var.subnets["public"])
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets.public[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.vpc_tags , {Name = "${var.env}-public" }  )
  }


resource "aws_subnet" "web_subnet" {
  count = length(var.subnets["web"])
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets.web[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.vpc_tags , {Name = "${var.env}-web" }  )
  }

resource "aws_subnet" "backend_subnet" {
  count = length(var.subnets["backend"])
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets.backend[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.vpc_tags , {Name = "${var.env}-backend" }  )
  }

resource "aws_subnet" "db_subnet" {
  count = length(var.subnets["db"])
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
  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }
  tags = merge(var.vpc_tags , {Name = "public" }  )
}

resource "aws_route_table" "webRT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }
  tags = merge(var.vpc_tags , {Name = "web" }  )
}

resource "aws_route_table" "backendRT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }
  tags = merge(var.vpc_tags , {Name = "backend" }  )
}

resource "aws_route_table" "dbRT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }
  tags = merge(var.vpc_tags , {Name = "db" }  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "main" {
  domain = "vpc"
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

resource "aws_vpc_peering_connection" "main" {
  peer_owner_id = var.account_id
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept = true
}

#Add peering connection in route tables # added as route in the subnets' respective RTs # added as route in default vpc's RT

resource "aws_route" "default_vpc_route" {
  route_table_id            = var.default_vpc_rt
  destination_cidr_block    = var.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

#sending output of vpc_id to parent module, so that it will used in app module's sg-lt security group vpc_id
output "vpc_id" {
  value = aws_vpc.main.id
}
output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}