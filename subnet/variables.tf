variable "vpc_id" {}
variable "vpc_cidr_block" {}

variable "availability_zones" {
  default     = []
  description = "List of availability zone names to use. If not specified, all of them will be used"
  type        = list(string)
}

variable "subnets" {
  default     = []
  description = "List of subnets. If 'zone' is a empty string, the module will decide which availability zone to put the subnet in"

  type = list(object({
    cidr = string
    zone = string
    tags = map(string)
  }))
}

variable "tags" {
  default     = {}
  description = "Resource's tags"
  type        = map
}