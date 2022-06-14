resource "helm_release" "nginx" {
  provider = helm.provider

  name       = "nginx"
  chart      = "nginx"
  repository = "https://charts.bitnami.com/bitnami"
}
