resource "kubernetes_service_account" "mysql-service-master-account" {
  metadata {
    name      = var.service_account_master
    namespace = var.namespace
  }
}

resource "kubernetes_service_account" "mysql-service-slave-account" {
  metadata {
    name      = var.service_account_slave
    namespace = var.namespace
  }
}

resource "kubernetes_service" "mysql-master-service" {
  metadata {
    name      = var.mysql_master_service_name
    namespace = var.namespace
  }
  spec {
    selector = {
      name = var.mysql_master_service_name
    }

    port {
      name        = "mysql-master-port"
      port        = var.mysql_port
      target_port = var.mysql_port
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service" "mysql-slave-service" {
  metadata {
    name      = var.mysql_slave_service_name
    namespace = var.namespace
  }
  spec {
    selector = {
      name = var.mysql_slave_service_name
    }

    port {
      name        = "mysql-slave-port"
      port        = var.mysql_port
      target_port = var.mysql_port
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_config_map" "mysql-configmap" {
  metadata {
    name      = var.config_name
    namespace = var.namespace
  }

  data = {
    username         = var.username
    replication-user = var.replication_username
    database-name    = var.db_name
  }
}

resource "kubernetes_stateful_set" "mysql-master-statefulset" {
  metadata {

    labels = {
      name                              = var.mysql_master_service_name
      "kubernetes.io/cluster-service"   = "true"
      "addonmanager.kubernetes.io/mode" = "Reconcile"
    }

    name      = var.st_master_name
    namespace = var.namespace
  }

  spec {
    pod_management_policy  = "Parallel"
    replicas               = 1
    revision_history_limit = 5

    selector {
      match_labels = {
        name = var.mysql_master_service_name
      }
    }

    service_name = var.mysql_master_service_name

    template {
      metadata {
        labels = {
          name = var.mysql_master_service_name
        }

        annotations = {}
      }

      spec {
        service_account_name = var.service_account_master

        container {
          name              = var.container_name_master
          image             = var.image_reference_master
          image_pull_policy = "Always"

          args = []

          port {
            container_port = var.mysql_port
          }

          env {
            name = "MYSQL_USER"
            value_from {
              config_map_key_ref {
                name = var.config_name
                key  = "username"
              }
            }
          }
          env {
            name = "MYSQL_DATABASE"
            value_from {
              config_map_key_ref {
                name = var.config_name
                key  = "database-name"
              }
            }
          }
          env {
            name = "MYSQL_REPLICATION_USER"
            value_from {
              config_map_key_ref {
                name = var.config_name
                key  = "replication-user"
              }
            }
          }
          env {
            name = "MYSQL_REPLICATION_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "mysql-replication-password"
              }
            }
          }
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "mysql-master-password"
              }
            }
          }
          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "mysql-master-password"
              }
            }
          }

          resources {
            limits {
              cpu    = "200m"
              memory = "500Mi"
            }

            requests {
              cpu    = "200m"
              memory = "500Mi"
            }
          }
        }
      }
    }

    update_strategy {
      type = "RollingUpdate"

      rolling_update {
        partition = 1
      }
    }
  }
}

resource "kubernetes_stateful_set" "mysql-slave-statefulset" {
  metadata {

    labels = {
      name                              = var.mysql_slave_service_name
      "kubernetes.io/cluster-service"   = "true"
      "addonmanager.kubernetes.io/mode" = "Reconcile"
    }

    name      = var.st_slave_name
    namespace = var.namespace
  }

  spec {
    pod_management_policy  = "Parallel"
    replicas               = 1
    revision_history_limit = 5

    selector {
      match_labels = {
        name = var.mysql_slave_service_name
      }
    }

    service_name = var.mysql_slave_service_name

    template {
      metadata {
        labels = {
          name = var.mysql_slave_service_name
        }

        annotations = {}
      }

      spec {
        service_account_name = var.service_account_slave

        container {
          name              = var.container_name_slave
          image             = var.image_reference_slave
          image_pull_policy = "IfNotPresent"

          args = []

          port {
            container_port = var.mysql_port
          }

          env {
            name = "MYSQL_REPLICATION_USER"
            value_from {
              config_map_key_ref {
                name = var.config_name
                key  = "replication-user"
              }
            }
          }
          env {
            name = "MYSQL_REPLICATION_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "mysql-replication-password"
              }
            }
          }
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "mysql-master-password"
              }
            }
          }

          resources {
            limits {
              cpu    = "200m"
              memory = "500Mi"
            }

            requests {
              cpu    = "200m"
              memory = "500Mi"
            }
          }
        }
      }
    }

    update_strategy {
      type = "RollingUpdate"

      rolling_update {
        partition = 1
      }
    }
  }
}

