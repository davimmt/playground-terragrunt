include "root" {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../eks-cluster"

  mock_outputs = {
    eks_cluster = { name = "mock", endpoint = "mock", certificate_authority = [ { data = "bW9jaw==" } ] }
  }
}

dependency "oidc" {
  config_path = "../iam-oidc-provider"

  mock_outputs = {
    oidc_provider = { url = "mock" }
  }
}

inputs = {
  eks_cluster = dependency.eks.outputs.eks_cluster
  oidc_provider = dependency.oidc.outputs.oidc_provider
}