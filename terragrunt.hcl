remote_state {
    backend = "local"

    generate = {
      path      = "backend.tf"
      if_exists = "overwrite_terragrunt"
    }

    config = {
      path = ".tfstate/terraform.tfstate"
    }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
locals {
  override_default_tags = {}
  default_tags = {
    Squad = "devops"
    Terragrunt = "true"
    Environment = "POC"
    Path = "${path_relative_to_include()}"
  }

  override_ignore_tags_key_prefixes = []
  ignore_tags_key_prefixes = []
    
  override_ignore_tags_keys = []
  ignore_tags_keys = []
}

provider "aws" {
  default_tags { tags = merge(local.default_tags, local.override_default_tags) }
  region = "us-west-2"

  ignore_tags {
    keys = concat(local.ignore_tags_keys, local.override_ignore_tags_keys)
    key_prefixes = concat(local.ignore_tags_key_prefixes, local.override_ignore_tags_key_prefixes)
  }
}
EOF
}

terraform {
  extra_arguments "conditional_vars" {
    commands = [
      "apply",
      "plan",
      "refresh",
      "destroy"
    ]

    required_var_files = [
      "${get_parent_terragrunt_dir()}/terraform.tfvars"
    ]

    optional_var_files = [
      "${get_parent_terragrunt_dir()}/${get_env("TF_VAR_env", "dev")}.tfvars",
      "${get_parent_terragrunt_dir()}/${get_env("TF_VAR_region", "us-east-1")}.tfvars",
      "${get_terragrunt_dir()}/${get_env("TF_VAR_env", "dev")}.tfvars",
      "${get_terragrunt_dir()}/${get_env("TF_VAR_region", "us-east-1")}.tfvars"
    ]
  }
}