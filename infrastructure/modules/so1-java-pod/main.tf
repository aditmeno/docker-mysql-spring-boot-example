resource "kubernetes_service" "so1-java-app-service" {
  metadata {
    name      = var.so1_java_service_name
    namespace = var.namespace
  }
  spec {
    selector = {
      app = var.deploy_name
    }

    port {
      name        = "so1-java-app-port"
      port        = var.port
      target_port = var.port
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "so1-java-app-deploy" {
  metadata {
    name      = var.deploy_name
    namespace = var.namespace
    labels = {
      app = var.deploy_name
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = var.deploy_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.deploy_name
        }
      }

      spec {
        container {
          image = "${var.container_image}:${var.image_version_tag}"
          name  = var.deploy_name

          port {
            name           = "port"
            container_port = var.port
          }

          env {
            name  = "SPRING_DATASOURCE_URL"
            value = var.mysql_host
          }
          # Need a more powerful instance to figure out how long Spring Boot takes to boot. Minikube widly distorts this to make a sensible initial_delay_seconds prediction
          # Commented out for now, needs to be tested with 15s, 30s. Needed to ensure pod is spun if it's unhealthy
          #   liveness_probe {
          #     http_get {
          #       path = "/all/"
          #       port = var.port

          #       http_header {
          #         name  = "X-Custom-Header"
          #         value = "K8 Verifier"
          #       }
          #     }

          #     initial_delay_seconds = 10
          #     period_seconds        = 3
          #   }
        }
      }
    }
  }
}
