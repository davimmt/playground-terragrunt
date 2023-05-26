variable "eks_cluster" {}
variable "oidc_provider" {}

variable "argocd_root_repo_ssm_parameter_name" {
  description = "Path name for the SSM Parameter that contains the SSH Private Key that enables access to var.argocd_root_repo_url"
}

variable "argocd_root_repo_url" {
  description = "Git repository URL to be configured at first for ArgoCD"
}

variable "argocd_root_repo_app_of_apps_path" {
  description = "Git repository URL to be configured at first for ArgoCD"
}
