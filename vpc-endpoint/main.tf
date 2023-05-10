# data "aws_subnets" "all" {}
# data "aws_subnet" "all" {
#   for_each = toset(data.aws_subnets.all.ids)
#   id       = each.value
# }