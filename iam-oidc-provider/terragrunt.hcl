include "root" {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../eks-cluster"

  mock_outputs = {
    tls_certificate = "mock"
    oidc_provider_url = "mock"
  }
}

inputs = {
  tls_certificate = dependency.eks.outputs.eks_cluster.identity[0].oidc[0].issuer
  oidc_provider_url = dependency.eks.outputs.eks_cluster.identity[0].oidc[0].issuer
}