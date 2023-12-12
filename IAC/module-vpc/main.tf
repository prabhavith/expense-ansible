resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags = merge( {Name = "${var.env}"}, var.vpc_tags )

resource "aws_subnet" "public_subnet" {
  count = var.subnets["public"]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets.public[count.index]
  tags = merge(var.vpc_tags , {Name = "${var.env}-public" }  )
  }
}


resource "aws_subnet" "web_subnet" {
  count = var.subnets["web"]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets.web[count.index]
  tags = {
    Name = "Main"
  }
}


resource "aws_subnet" "backend_subnet" {
  count = var.subnets["backend"]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets.backend[count.index]
  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "db_subnet" {
  count = var.subnets["db"]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets.db[count.index]
  tags = {
    Name = "Main"
  }
}
