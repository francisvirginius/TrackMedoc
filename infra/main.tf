terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

# ── NAMESPACE ──────────────────────────────────────────────
resource "kubernetes_namespace" "truck_medoc" {
  metadata {
    name = var.namespace
    labels = {
      name        = var.namespace
      environment = var.environment
    }
  }
}

# ── SECRET MYSQL ───────────────────────────────────────────
resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = kubernetes_namespace.truck_medoc.metadata[0].name
  }

  data = {
    database      = var.mysql_database
    user          = var.mysql_user
    password      = var.mysql_password
    root-password = var.mysql_root_password
  }
}

# ── CONFIGMAP API ──────────────────────────────────────────
resource "kubernetes_config_map" "api_config" {
  metadata {
    name      = "api-config"
    namespace = kubernetes_namespace.truck_medoc.metadata[0].name
  }

  data = {
    MYSQL_HOST = "mysql-service"
    MYSQL_PORT = "3306"
  }
}

# ── MYSQL DEPLOYMENT ───────────────────────────────────────
resource "kubernetes_deployment" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.truck_medoc.metadata[0].name
    labels = {
      app = "mysql"
    }
  }

  spec {
    replicas = 1

    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:8.0"

          port {
            container_port = 3306
            name           = "mysql"
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "root-password"
              }
            }
          }

          env {
            name = "MYSQL_DATABASE"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "database"
              }
            }
          }

          env {
            name = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "user"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "mysql-storage"
            mount_path = "/var/lib/mysql"
          }

          volume_mount {
            name       = "mysql-init"
            mount_path = "/docker-entrypoint-initdb.d"
          }

          resources {
            requests = {
              memory = "256Mi"
              cpu    = "250m"
            }
            limits = {
              memory = "512Mi"
              cpu    = "500m"
            }
          }
        }

        volume {
          name = "mysql-storage"
          empty_dir {}
        }

        volume {
          name = "mysql-init"
          config_map {
            name = "mysql-init-script"
          }
        }
      }
    }
  }

  depends_on = [kubernetes_secret.mysql_secret]
}

# ── MYSQL SERVICE ──────────────────────────────────────────
resource "kubernetes_service" "mysql_service" {
  metadata {
    name      = "mysql-service"
    namespace = kubernetes_namespace.truck_medoc.metadata[0].name
    labels = {
      app = "mysql"
    }
  }

  spec {
    selector = {
      app = "mysql"
    }

    port {
      port        = 3306
      target_port = 3306
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# ── API DEPLOYMENT ─────────────────────────────────────────
resource "kubernetes_deployment" "api" {
  metadata {
    name      = "truck-medoc-api"
    namespace = kubernetes_namespace.truck_medoc.metadata[0].name
    labels = {
      app = "truck-medoc-api"
    }
  }

  spec {
    replicas = var.api_replicas

    selector {
      match_labels = {
        app = "truck-medoc-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "truck-medoc-api"
        }
      }

      spec {
        container {
          name  = "api"
          image = "${var.docker_username}/truck-medoc-api:${var.api_image_tag}"

          port {
            container_port = 8080
            name           = "http"
          }

          env {
            name = "MYSQL_HOST"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.api_config.metadata[0].name
                key  = "MYSQL_HOST"
              }
            }
          }

          env {
            name = "MYSQL_PORT"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.api_config.metadata[0].name
                key  = "MYSQL_PORT"
              }
            }
          }

          env {
            name = "MYSQL_DATABASE"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "database"
              }
            }
          }

          env {
            name = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "user"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "password"
              }
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }

          resources {
            requests = {
              memory = "128Mi"
              cpu    = "100m"
            }
            limits = {
              memory = "256Mi"
              cpu    = "200m"
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_deployment.mysql]
}

# ── API SERVICE ────────────────────────────────────────────
resource "kubernetes_service" "api_service" {
  metadata {
    name      = "api-service"
    namespace = kubernetes_namespace.truck_medoc.metadata[0].name
    labels = {
      app = "truck-medoc-api"
    }
  }

  spec {
    selector = {
      app = "truck-medoc-api"
    }

    port {
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
      name        = "http"
    }

    type = "ClusterIP"
  }
}

# ── FRONTEND DEPLOYMENT ────────────────────────────────────
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "truck-medoc-frontend"
    namespace = kubernetes_namespace.truck_medoc.metadata[0].name
    labels = {
      app = "truck-medoc-frontend"
    }
  }

  spec {
    replicas = var.frontend_replicas

    selector {
      match_labels = {
        app = "truck-medoc-frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "truck-medoc-frontend"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = "${var.docker_username}/truck-medoc-frontend:${var.frontend_image_tag}"

          port {
            container_port = 80
            name           = "http"
          }

          resources {
            requests = {
              memory = "64Mi"
              cpu    = "50m"
            }
            limits = {
              memory = "128Mi"
              cpu    = "100m"
            }
          }
        }
      }
    }
  }
}

# ── FRONTEND SERVICE ───────────────────────────────────────
resource "kubernetes_service" "frontend_service" {
  metadata {
    name      = "frontend-service"
    namespace = kubernetes_namespace.truck_medoc.metadata[0].name
    labels = {
      app = "truck-medoc-frontend"
    }
  }

  spec {
    selector = {
      app = "truck-medoc-frontend"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}
