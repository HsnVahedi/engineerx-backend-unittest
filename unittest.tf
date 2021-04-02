resource "kubernetes_pod" "unittest" {
  metadata {
    name      = "unittest-${var.test_number}"
    namespace = "backend-test"

    labels = {
      app  = "backend"
      role = "backend-test"
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

      env {
        name = "SECRET_KEY"

        value_from {
          secret_key_ref {
            name = kubernetes_secret.django_secret_key.metadata[0].name
            key  = "secret_key"
          }
        }
      }

      env {
        name = "ALLOWED_HOST"
        value = "*"
      }

      resources {
        limits = {
          cpu    = "1200m"
          memory = "512Mi"
        }

        requests = {
          memory = "256Mi"
          cpu    = "800m"
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

        initial_delay_seconds = 60
        period_seconds        = 5
      }

      readiness_probe {
        http_get {
          path = "/"
          port = "8000"
        }

        initial_delay_seconds = 100
        period_seconds        = 5
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

      resources {
        limits = {
          cpu    = "300m"
          memory = "1024Mi"
        }

        requests = {
          memory = "512Mi"
          cpu    = "200m"
        }
      }

    }

    image_pull_secrets {
      name = kubernetes_secret.dockerhub_cred.metadata[0].name
    }
  }
}

