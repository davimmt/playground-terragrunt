variable "vpc_id" {}
variable "output_subnets" {}
variable "vpc_endpoints" {}

variable "default_route_table_name" {
  default     = "LOCAL"
  description = "Default route table name for subnets without RT defined"
  type        = string
}

variable "route_tables" {}

variable "tags" {
  default     = {}
  description = "Resource's tags"
  type        = map
}