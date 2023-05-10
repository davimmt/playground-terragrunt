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
    tags = { Name = "BKE-1", NACL = "BKE" }
  },
  {
    cidr = "10.50.4.0/24"
    zone = "us-west-2d"
    tags = { Name = "BKE-2", NACL = "BKE" }
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
          cidr_block = "10.0.0.0/8"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 22
          to_port    = 22
        }
      ],
      egress = [
        {
          cidr_block = "10.0.0.0/8"
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
          cidr_block = "10.0.0.0/8"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 22
          to_port    = 22
        }
      ],
      egress = [
        {
          cidr_block = "10.0.0.0/8"
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
    name  = "BKE"
    rules = {
      ingress = [
        {
          cidr_block = "10.0.0.0/8"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 22
          to_port    = 22
        }
      ],
      egress = [
        {
          cidr_block = "10.0.0.0/8"
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
    name  = "DTB"
    rules = {
      ingress = [
        {
          cidr_block = "10.0.0.0/8"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 22
          to_port    = 22
        }
      ],
      egress = [
        {
          cidr_block = "10.0.0.0/8"
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          from_port  = 22
          to_port    = 22
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