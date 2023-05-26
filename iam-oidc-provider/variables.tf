variable "tls_certificate" {}
variable "oidc_provider_url" {}

variable "oidc_provider_client_ids" {
  default     = ["sts.amazonaws.com"]
  description = ""
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "Resource's tags"
  type        = map
}