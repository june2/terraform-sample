resource "kubernetes_namespace" "env_namespae" {
  metadata {
    name = local.environment
  }
}

# 서비스 인그레스 생성
resource "kubernetes_manifest" "service_ingress" {
  manifest = yamldecode(file("./spec-file/${local.environment}.service.ingress-rule.yml"))

  wait {
    fields = {
      "status.loadBalancer.ingress[0].hostname" = "*"
    }
  }

  depends_on = [
    local.cluster_id,
    kubernetes_namespace.env_namespae
  ]
}

data "kubernetes_ingress_v1" "service_ingress" {
  metadata {
    name      = "service-ingress"
    namespace = "default"
  }

  depends_on = [
    kubernetes_manifest.service_ingress
  ]
}

data "aws_route53_zone" "zone" {
  name         = "mosaicsquare.io."
  private_zone = false
}

# route 53 record
resource "aws_route53_record" "route53" {
  zone_id = data.aws_route53_zone.zone.zone_id  
  name    = "*${local.environment == "prod" ? "" : ".${local.environment}"}.mosaicsquare.io"    
  type    = "CNAME"
  ttl     = "300"
  records = [
    data.kubernetes_ingress_v1.service_ingress.status.0.load_balancer.0.ingress.0.hostname,    
  ]
}
