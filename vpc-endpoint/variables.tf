variable "vpc_id" {}
variable "output_subnets" {}

variable "create_igw" {
  default     = true
  description = "Whether create and attach a Internet Gateway to the VPC"
  type        = bool
}

variable "tags" {
  default     = {}
  description = "Resource's tags"
  type        = map
}