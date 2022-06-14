data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "eks.amazonaws.com",
        "route53.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "instance-route53-role-policy" {
  statement {
    effect  = "Allow"
    actions = ["route53:ChangeResourceRecordSets"]
    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "eks-iam-role" {
  name = "eks-${var.environment}-${var.target}-${random_id.id.hex}-iam-role"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_role" "eks-worker-nodes" {
  name = "eks-${var.environment}-${var.target}-${random_id.id.hex}-worker-nodes"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_role" "route53-iam-role" {
  name = "eks-${var.environment}-${var.target}-${random_id.id.hex}-route53-role"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_role_policy" "AmazonRoute53_Policy" {
  policy = data.aws_iam_policy_document.instance-route53-role-policy.json
  role   = aws_iam_role.route53-iam-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSCluster_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-iam-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-worker-nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNode_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-worker-nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-worker-nodes.name
}
