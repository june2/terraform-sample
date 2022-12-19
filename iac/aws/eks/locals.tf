resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  env = {
    dev = {
      region                    = "ap-northeast-2"
      ip_range_prefix           = "10.10"
      cluster_service_ipv4_cidr = "10.15.0.0/16"
      subdomain                 = "dev"
      node_groups = {
        mos_apps_dev = {
          name         = "mos-apps-dev"
          min_size     = 2
          max_size     = 5
          desired_size = 2

          instance_types = ["t3.medium"]

          /** SPOT / ON_DEMAND */
          capacity_type = "SPOT"

          labels = {
            Environment = local.environment,
            target      = "application-service"
          }

          tags = {
            Name     = "${local.eks_cluster_name}-app"
            ExtraTag = "application"
          }

          # s3 access policy attach
          # iam_role_additional_policies = [
          #   "arn:aws:iam::aws:policy/AmazonS3FullAccess",
          #   "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
          # ]

          # disk_size = 50
          # disk_type = "gp3"
          block_device_mappings = {
            xvda = {
              device_name = "/dev/xvda"
              ebs = {
                volume_size = 32
                volume_type = "gp3"
                iops        = 3000
                throughput  = 150
              }
            }
          }

          update_config = {
            max_unavailable_percentage = 50
          }
        }
      }
    }

    prod = {
      region                    = "ap-northeast-2" // 서울
      ip_range_prefix           = "10.20"
      cluster_service_ipv4_cidr = "10.25.0.0/16"
      subdomain                 = "prod"
      node_groups = {
        mos_apps_prod = {
          name         = "mos-apps-prod"
          min_size     = 2
          max_size     = 5
          desired_size = 2

          instance_types = ["t3.medium"]

          /** SPOT / ON_DEMAND */
          capacity_type = "ON_DEMAND"

          labels = {
            Environment = local.environment,
            target      = "application-service"
          }

          tags = {
            Name     = "${local.eks_cluster_name}-app"
            ExtraTag = "application"
          }

          # s3 access policy attach
          # iam_role_additional_policies = [
          #   "arn:aws:iam::aws:policy/AmazonS3FullAccess",
          #   "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
          # ]

          # disk_size = 50
          # disk_type = "gp3"
          block_device_mappings = {
            xvda = {
              device_name = "/dev/xvda"
              ebs = {
                volume_size = 32
                volume_type = "gp3"
                iops        = 3000
                throughput  = 150
              }
            }
          }

          update_config = {
            max_unavailable_percentage = 50
          }
        }
      }
    }
  }

  name        = "mos"
  environment = terraform.workspace
  subdomain   = local.env[terraform.workspace].subdomain
  region      = local.env[terraform.workspace].region

  postfix                   = random_string.suffix.result
  vpc_name                  = "vpc-${local.name}-${local.environment}-${local.postfix}"
  eks_cluster_name          = "eks-${local.name}-${local.environment}-${local.postfix}"
  ip_range_prefix           = local.env[terraform.workspace].ip_range_prefix
  cluster_service_ipv4_cidr = local.env[terraform.workspace].cluster_service_ipv4_cidr

  # alb 컨트롤러 설정 관련
  lb_controller_iam_role_name        = "role-${local.name}-${local.environment}-lb-controller"
  lb_controller_service_account_name = "account-${local.name}-${local.environment}-lb"

  # auto cluster 관련
  policy_autocaling_name = "policy-cluster-autoscaler-${local.eks_cluster_name}"
  policy_autocaling_prefix = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy"
  policy_autocaling_arn = "${local.policy_autocaling_prefix}/${local.policy_autocaling_name}"
}

