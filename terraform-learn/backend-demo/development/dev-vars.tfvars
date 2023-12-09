env = "dev"
component = {
  front = {
    name = "frontend-dev"
    type = "t2.micro"
    ami = "ami-03265a0778a880afb"
  }
  back = {
    name = "backend-dev"
    type = "t3.micro"
    ami = "ami-03265a0778a880afb"
  }
  db = {
    name = "database-dev"
    type = "t2.small"
    ami = "ami-03265a0778a880afb"
  }
}