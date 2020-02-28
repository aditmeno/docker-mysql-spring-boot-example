resource "kubernetes_secret" "secrets" {
  metadata {
    name      = var.secrets_name
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    mysql-master-password      = var.mysql_master_password
    mysql-replication-password = var.mysql_replication_password
  }
}

