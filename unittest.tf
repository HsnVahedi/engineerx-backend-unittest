resource "kubernetes_pod" "unittest" {
  metadata {
    name      = "unittest-${var.test_number}"
    namespace = "backend-unittest"

    labels = {
      app  = "backend"
      role = "unittest"
    }
  }

  spec {
    volume {
      name = "data"
    }

    container {
      name    = "backend"
      image   = "hsndocker/backend:${var.backend_version}"
      command = ["/bin/bash", "-c", "rm manage.py && mv manage.unittest.py manage.py && rm engineerx/wsgi.py && mv engineerx/wsgi.unittest.py engineerx/wsgi.py && ./start.sh"]

      port {
        container_port = 8000
      }

      env {
        name = "POSTGRES_PASSWORD"

        value_from {
          secret_key_ref {
            name = kubernetes_secret.postgres_password.metadata[0].name
            key  = "password"
          }
        }
      }

      resources {
        limits = {
          cpu    = "6000m"
          memory = "256Mi"
        }

        requests = {
          memory = "128Mi"
          cpu    = "200m"
        }
      }

      volume_mount {
        name       = "data"
        mount_path = "/app/static"
        sub_path   = "static"
      }

      volume_mount {
        name       = "data"
        mount_path = "/app/media"
        sub_path   = "media"
      }

      liveness_probe {
        http_get {
          path = "/"
          port = "8000"
        }

        initial_delay_seconds = 10
        period_seconds        = 10
      }

      readiness_probe {
        http_get {
          path = "/"
          port = "8000"
        }

        initial_delay_seconds = 60
        period_seconds        = 40
      }

    }

    container {
      name  = "postgres"
      image = "hsndocker/backend-postgres:${var.backend_version}"

      port {
        container_port = 5432
      }

      env {
        name = "POSTGRES_PASSWORD"

        value_from {
          secret_key_ref {
            name = kubernetes_secret.postgres_password.metadata[0].name
            key  = "password"
          }
        }
      }

      volume_mount {
        name       = "data"
        mount_path = "/var/lib/postgresql/data"
        sub_path   = "postgres"
      }

    }

    image_pull_secrets {
      name = kubernetes_secret.dockerhub_cred.metadata[0].name
    }
  }
}

resource "kubernetes_secret" "postgres_password" {
  metadata {
    name      = "postgres-password-${var.test_number}"
    namespace = "backend-unittest"
    labels = {
      role = "deployment"
    }
  }

  data = {
    password = "777kkdo##$%%!!kdkdkd"
  }
}

resource "kubernetes_secret" "dockerhub_cred" {
  metadata {
    name = "dockerhub-cred"
    namespace = "backend-unittest"
    labels = {
      role = "unittest"
    }
  }

  data = {
      ".dockerconfigjson" = "ewoJImF1dGhzIjogewoJCSJodHRwczovL2luZGV4LmRvY2tlci5pby92MS8iOiB7CgkJCSJhdXRo\nIjogImFITnVaRzlqYTJWeU9sTmpZVzVrYVc1aGRtbGhRREU9IgoJCX0KCX0KfQ=="
  }
  type = "kubernetes.io/dockerconfigjson"
}
