#################
## Variables data
#################
data "aws_subnets" "private" {
  count = length(var.subnet_ids.private) > 0 ? 0 : 1

  filter {
    name   = "tag:kubernetes.io/cluster/${var.cluster_name}"
    values = ["owned", "shared"]
  }

  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = [1]
  }
}

data "aws_subnets" "public" {
  count = length(var.subnet_ids.public) > 0 ? 0 : 1

  filter {
    name   = "tag:kubernetes.io/cluster/${var.cluster_name}"
    values = ["owned", "shared"]
  }

  filter {
    name   = "tag:kubernetes.io/role/elb"
    values = [1]
  }
}

locals {
  subnet_public_ids  = length(var.subnet_ids.public) > 0 ? var.subnet_ids.public : data.aws_subnets.public[0].ids
  subnet_private_ids = length(var.subnet_ids.private) > 0 ? var.subnet_ids.private : data.aws_subnets.private[0].ids
}

##############
## EKS Cluster
##############
resource "aws_iam_role" "iam_role_eks_cluster" {
  name                = "TerraformEKSCluster-${var.cluster_name}"
  assume_role_policy  = file("${path.module}/assume_role_policies/aws_eks.tpl")
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
  tags                = merge(var.tags, { Name = "AmazonEKSClusterPolicy" })
}

resource "aws_kms_key" "eks" {
  description = "KMS key for ${var.cluster_name} EKS Cluster"
}

# Must be before aws_eks_cluster resource
resource "aws_cloudwatch_log_group" "eks_cluster" {
  count             = length(var.enabled_cluster_log_types) > 0 ? 1 : 0
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
}

# Must depend on aws_cloudwatch_log_group.eks_cluster
resource "aws_eks_cluster" "eks" {
  name       = var.cluster_name
  role_arn   = aws_iam_role.iam_role_eks_cluster.arn
  version    = var.cluster_version
  tags       = merge(var.tags, { Name = var.cluster_name })
  depends_on = [aws_iam_role.iam_role_eks_cluster, aws_cloudwatch_log_group.eks_cluster]
  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    subnet_ids              = concat(local.subnet_public_ids, local.subnet_private_ids)
    security_group_ids      = var.security_group_ids
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
    endpoint_public_access  = length(local.subnet_public_ids) > 0 ? true : false
    endpoint_private_access = var.cluster_endpoint_private_access
  }

  encryption_config {
    resources = ["secrets"]

    provider {
      key_arn = aws_kms_key.eks.arn
    }
  }
}

resource "aws_iam_role" "iam_role_node_group" {
  name               = "TerraformEKSNodeGroup-${aws_eks_cluster.eks.name}"
  assume_role_policy = file("${path.module}/assume_role_policies/aws_eks_node_group.tpl")
  tags               = merge(var.tags, {})

  managed_policy_arns = concat([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ], var.node_policy_arns)
}

resource "aws_eks_node_group" "eks_node_group" {
  depends_on      = [aws_eks_cluster.eks, aws_iam_role.iam_role_node_group]
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = aws_eks_cluster.eks.name
  node_role_arn   = aws_iam_role.iam_role_node_group.arn
  subnet_ids      = local.subnet_private_ids
  capacity_type   = "ON_DEMAND"
  ami_type        = var.ami_type
  disk_size       = var.node_disk_size
  instance_types  = [var.node_instance_type]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  tags = merge(var.tags, {
    "Name"                = "eks-node-${aws_eks_cluster.eks.name}"
    "k8s.io/cluster-name" = aws_eks_cluster.eks.name
    "k8s.io/cluster-autoscaler/enabled" = true
    "kubernetes.io/cluster/${aws_eks_cluster.eks.name}" = "owned"
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.eks.name}" = "owned"
  })
}