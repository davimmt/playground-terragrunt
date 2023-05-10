# data "aws_subnets" "all" {}
# data "aws_subnet" "all" {
#   for_each = toset(data.aws_subnets.all.ids)
#   id       = each.value
# }

resource "aws_network_acl" "nacl" {
  for_each = { for nacl in var.nacls: nacl.name => nacl }
  vpc_id   = var.vpc_id
  tags     = merge(var.tags, { Name = each.key })

  dynamic "ingress" {
    for_each = each.value.rules.ingress

    content {
      cidr_block = ingress.value.cidr_block
      rule_no    = ingress.value.rule_no
      protocol   = ingress.value.protocol
      action     = ingress.value.action
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = each.value.rules.egress

    content {
      cidr_block = egress.value.cidr_block
      rule_no    = egress.value.rule_no
      protocol   = egress.value.protocol
      action     = egress.value.action
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }
}

resource "aws_network_acl_association" "nacl_association" {
  for_each       = { for i, subnet in jsondecode(var.output_subnets): subnet.id => subnet.tags_all }
  network_acl_id = aws_network_acl.nacl[lookup(each.value, "NACL", var.default_nacl_name)].id
  subnet_id      = each.key
}