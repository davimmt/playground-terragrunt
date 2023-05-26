data "aws_default_tags" "default_tags" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  eks_cluster   = jsondecode(var.eks_cluster)
  oidc_provider = replace(jsondecode(var.oidc_provider).url, "https://", "")
}

#######################
## Kubernetes Providers
#######################
data "aws_eks_cluster_auth" "cluster_auth" {
  name = local.eks_cluster.name
}

provider "kubernetes" {
  host                   = local.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(local.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

provider "kubectl" {
  host                   = local.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(local.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = local.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(local.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster_auth.token
  }
}

#########
## ArgoCD
#########
resource "aws_iam_role" "argocd" {
  name = "${title(lower(data.aws_default_tags.default_tags.tags.Environment))}TerraformEKSArgoCD-${local.eks_cluster.name}"

  inline_policy {
    name = "${title(lower(data.aws_default_tags.default_tags.tags.Environment))}TerraformEKSArgoCD"

    policy = templatefile("${path.module}/policies/argocd.tpl", {
      account_id = data.aws_caller_identity.current.account_id
    })
  }

  assume_role_policy = templatefile("${path.module}/assume_role_policies/argocd.tpl", {
    account_id    = data.aws_caller_identity.current.account_id
    oidc_provider = local.oidc_provider
  })
}

data "aws_ssm_parameter" "argocd_repo" {
  name = var.argocd_root_repo_ssm_parameter_name
}

data "kubectl_path_documents" "argocd" {
  pattern = "${path.module}/manifests/argocd.yml"

  vars = {
    argocd_server_role_arn: aws_iam_role.argocd.arn
    argocd_repo_ssh_key: base64encode(data.aws_ssm_parameter.argocd_repo.value)
    argocd_repo_url: var.argocd_root_repo_url
  }
}

data "kubectl_path_documents" "argocd_app_of_apps" {
  pattern = "${path.module}/manifests/app-of-apps.yml"

  vars = {
    argocd_root_repo_url: var.argocd_root_repo_url
    argocd_root_repo_app_of_apps_path: var.argocd_root_repo_app_of_apps_path
    eks_cluster_name: local.eks_cluster.name
    eks_cluster_endpoint: local.eks_cluster.endpoint
    eks_cluster_oidc_provider: local.oidc_provider
    env: lower(data.aws_default_tags.default_tags.tags.Environment)
    aws_account_id: data.aws_caller_identity.current.account_id
    aws_region: data.aws_region.current.name
  }
}

resource "kubernetes_namespace" "argocd" {
  depends_on      = [data.kubectl_path_documents.argocd]
  metadata { name = "argocd" }
}

resource "kubectl_manifest" "argocd" {
  count              = 56
  yaml_body          = element(data.kubectl_path_documents.argocd.documents, count.index)
  override_namespace = "argocd"
  depends_on         = [kubernetes_namespace.argocd]
  lifecycle { ignore_changes = [yaml_body] }
}

resource "kubectl_manifest" "argocd_app_of_apps" {
  count              = 1
  yaml_body          = element(data.kubectl_path_documents.argocd_app_of_apps.documents, count.index)
  override_namespace = "argocd"
  depends_on         = [kubectl_manifest.argocd]
  lifecycle { ignore_changes = [yaml_body] }
}
