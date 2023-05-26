vpc_cidr_block = "10.50.0.0/16"

subnets = [
  {
    cidr = "10.50.0.0/25"
    zone = ""
    tags = { Name = "VPN-1", NACL = "VPN", RT = "IGW" }
  },
  {
    cidr = "10.50.0.128/25"
    zone = ""
    tags = { Name = "VPN-2", NACL = "VPN", RT = "IGW" }
  },
  {
    cidr = "10.50.1.0/24"
    zone = ""
    tags = { Name = "FTE-1", NACL = "FTE", RT = "IGW" }
  },
  {
    cidr = "10.50.2.0/24"
    zone = ""
    tags = { Name = "FTE-2", NACL = "FTE", RT = "IGW" }
  },
  {
    cidr = "10.50.3.0/24"
    zone = "us-west-2c"
    tags = { Name = "BKE-1", NACL = "BKE", "kubernetes.io/cluster/test-v1" = "owned", "kubernetes.io/role/internal-elb" = 1 }
  },
  {
    cidr = "10.50.4.0/24"
    zone = "us-west-2d"
    tags = { Name = "BKE-2", NACL = "BKE", "kubernetes.io/cluster/test-v1" = "owned", "kubernetes.io/role/internal-elb" = 1 }
  },
  {
    cidr = "10.50.5.0/24"
    zone = "us-west-2c"
    tags = { Name = "DTB-1", NACL = "DTB" }
  },
  {
    cidr = "10.50.6.0/24"
    zone = "us-west-2d"
    tags = { Name = "DTB-2", NACL = "DTB" }
  }
]

default_nacl_name = "VPN"
nacls = [
  {
    name  = "VPN"
    rules = {
      ingress = [
        {
          cidr_block = "0.0.0.0/0"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 22
          to_port    = 22
        }
      ],
      egress = [
        {
          cidr_block = "0.0.0.0/0"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 22
          to_port    = 22
        }
      ]
    }
  },
  {
    name  = "FTE"
    rules = {
      ingress = [
        {
          cidr_block = "0.0.0.0/0"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 443
          to_port    = 443
        }
      ],
      egress = [
        {
          cidr_block = "0.0.0.0/0"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 443
          to_port    = 443
        }
      ]
    }
  },
  {
    name  = "BKE"
    rules = {
      ingress = [
        {
          cidr_block = "10.50.1.0/24"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 8080
          to_port    = 8080
        },
        {
          cidr_block = "10.50.2.0/24"
          rule_no    = 101
          protocol   = "tcp"
          action     = "allow"
          from_port  = 8080
          to_port    = 8080
        }
      ],
      egress = [
        {
          cidr_block = "10.50.1.0/24"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 8080
          to_port    = 8080
        },
        {
          cidr_block = "10.50.2.0/24"
          rule_no    = 101
          protocol   = "tcp"
          action     = "allow"
          from_port  = 8080
          to_port    = 8080
        }
      ]
    }
  },
  {
    name  = "DTB"
    rules = {
      ingress = [
        {
          cidr_block = "10.50.3.0/24"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 5432
          to_port    = 5432
        },
        {
          cidr_block = "10.50.4.0/24"
          rule_no    = 101
          protocol   = "tcp"
          action     = "allow"
          from_port  = 5432
          to_port    = 5432
        }
      ],
      egress = [
        {
          cidr_block = "10.50.3.0/24"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 5432
          to_port    = 5432
        },
        {
          cidr_block = "10.50.4.0/24"
          rule_no    = 101
          protocol   = "tcp"
          action     = "allow"
          from_port  = 5432
          to_port    = 5432
        }
      ]
    }
  },
]

route_tables = [
  {
    name  = "LOCAL"
    routes = []
  },
  {
    name  = "IGW"
    routes = [
      {
        cidr_block   = "0.0.0.0/0"
        gateway_bool = true
      }
    ]
  }
]

cluster_name = "test-v1"
cluster_version = "1.24"
node_instance_type = "t3.micro"

argocd_root_repo_url = "git@bitbucket.org:somewhere/somewhat"
argocd_root_repo_app_of_apps_path = "app-of-apps-applications/dev"
argocd_root_repo_ssm_parameter_name = "/devops/DEV/eks/argocd/root_repo_ssh_private_key"