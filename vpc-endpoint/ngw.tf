resource "aws_eip" "eip" {
  for_each = {
    for i, subnet in jsondecode(var.output_subnets): subnet.tags_all.NGW => subnet.tags_all
    if lookup(subnet.tags_all, "NGW", false) != false
  }

  domain = "vpc"
  tags   = merge(var.tags, { Name = each.value.NGW })
}

resource "aws_nat_gateway" "ngw" {
  for_each = {
    for i, subnet in jsondecode(var.output_subnets): subnet.tags_all.NGW => subnet.id
    if lookup(subnet.tags_all, "NGW", false) != false
  }

  allocation_id = aws_eip.eip[each.key].id
  subnet_id     = each.value
  tags          = merge(var.tags, { Name = each.value.NGW })
}