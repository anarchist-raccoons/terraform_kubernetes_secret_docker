provider "kubernetes" {
#  load_config_file = false
  host = "${var.host}"
  username = "${var.username}"
  password = "${var.password}"
  client_certificate = "${var.client_certificate}"
  client_key = "${var.client_key}"
  cluster_ca_certificate = "${var.cluster_ca_certificate}"
}

# Secret for docker login
resource "kubernetes_secret" "default" {
  depends_on = ["null_resource.docker"]
  
  metadata {
    name = "${var.kubernetes_secret}"
  }
  data = {
    ".dockerconfigjson" = "${file("${path.cwd}/config.json")}"
  }
  type = "kubernetes.io/dockerconfigjson"
}

resource "null_resource" "docker" {
  # Run docker login
  provisioner "local-exec" {
    command = "export DOCKER_CONFIG=${path.cwd} && docker login ${var.docker_username}.azurecr.io -u ${var.docker_username} -p ${var.docker_password}"
  }
}
