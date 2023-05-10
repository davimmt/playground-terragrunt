variable "vpc_cidr_block" {}

variable "tags" {
  default     = {}
  description = "Resource's tags"
  type        = map
}