module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.3"

  cluster_endpoint_public_access = true
  cluster_name  = "myapp-eks-cluster"  
  cluster_version = "1.31"

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id     = module.myapp-vpc.vpc_id

  enable_cluster_creator_admin_permissions = true

  tags = {
    environment = "development"
    application = "myapp"
  }

  eks_managed_node_groups = {
    dev = {
      min_size     = 2
      max_size     = 10
      desired_size = 10

      instance_types = ["t2.small"]
    }
  }
}
