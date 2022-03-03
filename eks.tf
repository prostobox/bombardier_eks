data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_version = "1.21"
  cluster_name    = "bombardier"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets

  worker_groups_launch_template = [{
    name                       = "eks-nodes-bombardier-spot"
    override_instance_types    = ["m5.large", "m6g.large", "m5n.large", "m5zn.large"]
    autoscaling_enabled        = true
    public_ip                  = true
    root_delete_on_termination = true
    root_encrypted             = true
    root_volume_size           = 10
    root_volume_type           = "gp3"
    suspended_processes        = ["AZRebalance"]
    spot_price                 = "0.04"

    asg_min_size            = 3
    asg_max_size            = 3
    asg_desired_capacity    = 3
    spot_instance_pools     = 3
    on_demand_base_capacity = 0

    kubelet_extra_args = "--node-labels=node.kubernetes.io/lifecycle=`curl -s http://169.254.169.254/latest/meta-data/instance-life-cycle`"
    tags = [
      {
        "key"                 = "AutoOff"
        "value"               = "True"
        "propagate_at_launch" = "true"
      },
    ]
    }
  ]
}
