output "vpc_endpoints" {
  value = { "igw": aws_internet_gateway.igw, "ngw": aws_nat_gateway.ngw }
}