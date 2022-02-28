module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = "bombardier"
  cidr = "172.16.0.0/16"

  azs            = formatlist("%s%s", "eu-central-1", ["a", "b", "c"])
  public_subnets = ["172.16.112.0/22", "172.16.116.0/22", "172.16.120.0/22"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = false


  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options = true
}