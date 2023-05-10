variable "vpc_id" {}
variable "output_subnets" {}

variable "default_nacl_name" {}
variable "nacls" {}

variable "tags" {
  default     = {}
  description = "Resource's tags"
  type        = map
}