# module - cluster autoscaling policy
module "iam_policy_autoscaling" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = local.policy_autocaling_name
  path        = "/"
  description = "Autoscaling policy for cluster ${local.eks_cluster_name}"

  policy = data.aws_iam_policy_document.worker_autoscaling.json
}

# cluster autoscaling policy
data "aws_iam_policy_document" "worker_autoscaling" {
  statement {
    sid    = "eksWorkerAutoscalingAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerAutoscalingOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${local.eks_cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}

# cluster autoscaling helm 설정
resource "helm_release" "eks-autoscaling" {
  create_namespace = true
  namespace        = "kube-system"
  name             = "eks-autoscaling"
  repository       = "https://kubernetes.github.io/autoscaler"
  chart            = "cluster-autoscaler"
  version          = "9.21.0"

  set {
    name  = "autoDiscovery.clusterName"
    value = local.eks_cluster_name
  }

  set {
    name  = "autoDiscovery.enabled"
    value = "true"
  }

  set {
    name  = "cloudProvider"
    value = "aws"
  }

  set {
    name  = "awsRegion"
    value = "ap-northeast-2"
  }

  set {
    name  = "sslCertPath"
    value = "/etc/kubernetes/pki/ca.crt"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  # scale down enable
  set {
    name  = "extraArgs.scale-down-enabled"
    value = "true"
  }
  
  # 불필요한 노드를 스케일 다운하기 전까지 경과 시간
  set {
    name  = "extraArgs.scale-down-unneeded-time"
    value = "2m"
  }

  # 스케일 업 후 스케일 다운 평가가 다시 시작되기 전까지 경과 시간(유휴시간)
  set {
    name  = "extraArgs.scale-down-delay-after-add"
    value = "2m"
  }

  depends_on = [
    module.eks
  ]
}