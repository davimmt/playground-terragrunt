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

dependency "vpc_endpoint" {
  config_path = "../vpc-endpoint"

  mock_outputs = {
    vpc_endpoints = ["mock-vpc-endpoints"]
  }
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc.id
  output_subnets = dependency.subnet.outputs.subnets
  vpc_endpoints = dependency.vpc_endpoint.outputs.vpc_endpoints
}