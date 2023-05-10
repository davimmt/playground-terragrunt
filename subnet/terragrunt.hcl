include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id = "mock-vpc-id"
    vpc_cidr_block = "10.0.0.0/16"
  }
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc.id
  vpc_cidr_block = dependency.vpc.outputs.vpc.cidr_block
}