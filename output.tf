
output "kubernetes_secret_name" {
  value = "${kubernetes_secret.default.metadata.0.name}"
}
