resource "kubernetes_pod" "unittest" {
  metadata {
    name      = "unittest"
    namespace = "unittest"

    labels = {
      app  = "backend"
      role = "deployment"
    }
  }

  spec {
    volume {
      name = "data"
    }

    container {
      name    = "backend"
      image   = "hsndocker/backend-unittest:latest"
      command = ["bash"]
      args    = ["start.sh"]

      port {
        container_port = 8000
      }

      env {
        name = "POSTGRES_PASSWORD"

        value_from {
          secret_key_ref {
            name = "postgres-password"
            key  = "password"
          }
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

        initial_delay_seconds = 3
        period_seconds        = 3
      }

      readiness_probe {
        http_get {
          path = "/readiness"
          port = "8000"
        }

        initial_delay_seconds = 3
        period_seconds        = 3
      }

      #   image_pull_policy = "Never"
    }

    container {
      name  = "postgres"
      image = "hsndocker/backend-postgres:latest"

      port {
        container_port = 5432
      }

      env {
        name = "POSTGRES_PASSWORD"

        value_from {
          secret_key_ref {
            name = "postgres-password"
            key  = "password"
          }
        }
      }

      volume_mount {
        name       = "data"
        mount_path = "/var/lib/postgresql/data"
        sub_path   = "postgres"
      }

      #   image_pull_policy = "Never"
    }
  }
}

resource "kubernetes_secret" "postgres_password" {
  metadata {
    name      = "postgres-password"
    namespace = "unittest"
    labels = {
      role = "deployment"
    }
  }

  data = {
    password = "777kkdo##$%%!!kdkdkd"
  }
}