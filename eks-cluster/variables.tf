variable "cluster_name" {
  description = "Name of the cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores (^[0-9A-Za-z][A-Za-z0-9\\-_]+$)."
  type        = string
}

variable "cluster_version" {
  default     = "1.25"
  description = "Kubernetes Version"
  type        = string
}

variable "enabled_cluster_log_types" {
  default     = []
  description = "List of the desired control plane logging to enable"
  type        = list

  validation {
    condition = alltrue([
      for type in var.enabled_cluster_log_types : contains(["", "api", "audit", "authenticator", "controllerManager", "scheduler"], type)
    ])

    error_message = "Valid values include api, audit, authenticator, controllerManager, scheduler."
  }
}

variable "cluster_endpoint_public_access_cidrs" {
  default     = ["0.0.0.0/0"]
  description = "List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled."
  type        = list(string)
}

variable "cluster_endpoint_private_access" {
  default     = true
  description = "Whether the Amazon EKS private API server endpoint is enabled."
  type        = bool
}

variable "node_disk_size" {
  default     = 20
  description = "Disk size in GiB for worker nodes."
  type        = number
}

variable "node_policy_arns" {
  default     = []
  description = "ARN of additional policies to attach to the nodes' role"
  type        = list(string)
}

variable "node_instance_type" {
  default     = "t3a.large"
  description = "Type of node instance"
  type        = string
}

variable "ami_type" {
  default     = "AL2_x86_64"
  description = "(Optional) Type of Amazon Machine Image (AMI) associated with the EKS Node Group. See the AWS documentation for valid values. Terraform will only perform drift detection if a configuration value is provided."
  type        = string
}

variable "subnet_ids" {
  default = {
    private = []
    public  = []
  }

  description = "Subnet IDs"
  type        = object({ public = list(string), private = list(string)})
}

variable "security_group_ids" {
  default     = []
  description = "Security group IDs"
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "Resource's Tags"
  type        = map
}
