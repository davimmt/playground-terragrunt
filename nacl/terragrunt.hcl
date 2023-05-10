include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id = "mock-vpc-id"
  }
}


dependency "subnet" {
  config_path = "../subnet"

  mock_outputs = {
    subnets = ["mock-subnets"]
  }
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc.id
  output_subnets = dependency.subnet.outputs.subnets
}