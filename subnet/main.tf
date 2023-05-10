data "aws_availability_zones" "available" {
  count = length(var.availability_zones) == 0 ? 1 : 0
}

locals {
  azs = length(var.availability_zones) == 0 ? data.aws_availability_zones.available[0].names : var.availability_zones
}

resource "aws_subnet" "subnet" {
  for_each = { for i, subnet in var.subnets: subnet.cidr => merge(subnet, {
    "availability_zone_index" = ((i) % length(local.azs))
  })}

  vpc_id            = var.vpc_id
  cidr_block        = each.key
  availability_zone = each.value.zone == "" ? local.azs[each.value.availability_zone_index] : each.value.zone
  tags              = merge(var.tags, each.value.tags, {})

  lifecycle { ignore_changes = [ availability_zone ]}
}