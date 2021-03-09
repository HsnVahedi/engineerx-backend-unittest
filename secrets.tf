resource "kubernetes_secret" "dockerhub_cred" {
  metadata {
    name = "dockerhub-cred"
    namespace = "backend-unittest"
    labels = {
      role = "unittest"
    }
  }

  data = {
      ".dockerconfigjson" = "dddddd"
  }
  type = "kubernetes.io/dockerconfigjson"
}