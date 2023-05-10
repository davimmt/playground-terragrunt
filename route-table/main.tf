# data "aws_subnets" "all" {}
# data "aws_subnet" "all" {
#   for_each = toset(data.aws_subnets.all.ids)
#   id       = each.value
# }

locals {
  vpc_endpoints = jsondecode(var.vpc_endpoints)
}

resource "aws_route_table" "route_table" {
  for_each         = { for route_table in var.route_tables: route_table.name => route_table }
  vpc_id           = var.vpc_id
  tags             = merge(var.tags, { Name = each.key })
  propagating_vgws = []

  dynamic "route" {
    for_each = each.value.routes

    content {
      cidr_block     = route.value.cidr_block
      gateway_id     = lookup(route.value, "gateway_bool", null) == true ? local.vpc_endpoints.igw.id : null
      nat_gateway_id = lookup(route.value, "nat_gateway_name", false) != false ? local.vpc_endpoints.ngw[route.value.nat_gateway_name].id : null
    }
  }
}

resource "aws_route_table_association" "route_table_association" {
  for_each       = { for i, subnet in jsondecode(var.output_subnets): subnet.id => subnet.tags_all }
  subnet_id      = each.key
  route_table_id = aws_route_table.route_table[lookup(each.value, "RT", var.default_route_table_name)].id
}