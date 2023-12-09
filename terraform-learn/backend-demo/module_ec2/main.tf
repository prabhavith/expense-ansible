#component variable stores map of different components frontend, backend, database. By using for_each we call one by one keys of that map, which is used for iteration.
resource "aws_instance" "testing" {
  for_each = var.component
  ami      = each.value["ami"] //each.value is used to call the value of the key invoked by for_each
  type     = each.value["type"]
  tags     = {
    Name = each.value["name"]
    Environment = var.env
  }
}