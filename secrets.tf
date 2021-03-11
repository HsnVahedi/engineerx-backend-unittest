resource "kubernetes_secret" "postgres_password" {
  metadata {
    name      = "postgres-password-${var.test_number}"
    namespace = "backend-unittest"
    labels = {
      role = "backend-unittest"
    }
  }

  data = {
    password = "777kkdo##$%%!!kdkdkd"
  }
}

resource "kubernetes_secret" "dockerhub_cred" {
  metadata {
    name = "dockerhub-cred-${var.test_number}"
    namespace = "backend-unittest"
    labels = {
      role = "backend-unittest"
    }
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://index.docker.io/v1/": {
      "auth": "${base64encode("${var.dockerhub_username}:${var.dockerhub_password}")}"
    }
  }
}
DOCKER
  }

  type = "kubernetes.io/dockerconfigjson"
}
