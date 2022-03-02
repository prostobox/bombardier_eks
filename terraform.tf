terraform {
  required_providers {
    aws = {
      version = "~> 3.72.0"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}
