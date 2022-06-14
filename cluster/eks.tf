resource "aws_eks_cluster" "cluster" {
  name     = "eks-${var.environment}-${var.target}"
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    subnet_ids = concat(aws_subnet.public_subnet.*.id,
    aws_subnet.private_subnet.*.id)
  }

  depends_on = [
    aws_iam_role.eks-iam-role
  ]
}

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.environment}-${var.target}-worker-nodes"
  node_role_arn   = aws_iam_role.eks-worker-nodes.arn

  subnet_ids = aws_eks_cluster.cluster.vpc_config[0].subnet_ids

  instance_types = var.eks_worker_instance_types

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSCluster_Policy,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNode_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy.AmazonRoute53_Policy
  ]
}
