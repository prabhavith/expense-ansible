env = "prod"

component = {
  front = {
    name = "frontend-prd"
    type = "t3.small"
    ami = "ami-03265a0778a880afb"
  }
  back = {
    name = "backend-prd"
    type = "t2.small"
    ami = "ami-03265a0778a880afb"
  }
  db = {
    name = "database-prd"
    type = "t2.micro"
    ami = "ami-03265a0778a880afb"
  }
}