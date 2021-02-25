resource "kubernetes_pod" "unittest" {
  metadata {
    name      = "unittest-${var.test_number}"
    namespace = "unittest"

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
      image   = "hsndocker/backend-unittest:${var.backend_version}"
      command = ["bash"]
      args    = ["start.sh"]

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
          cpu = "1000m"
          memory = "512Mi"
        }

        requests = {
          memory = "256Mi"
          cpu    = "500m"
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
  }
}

resource "kubernetes_secret" "postgres_password" {
  metadata {
    name      = "postgres-password-${var.test_number}"
    namespace = "unittest"
    labels = {
      role = "deployment"
    }
  }

  data = {
    password = "777kkdo##$%%!!kdkdkd"
  }
}
