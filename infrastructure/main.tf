# Creates the namespace where apps are hosted
module "so1-namespace" {
  source = "./modules/so1-namespace"
}

# Configures app secrets
module "secrets" {
  source                     = "./modules/secrets"
  mysql_master_password      = var.mysql_master_password
  mysql_replication_password = var.mysql_replication_password
}

# Provisions a mysql db to store all the data
module "mysql-pods" {
  source = "./modules/mysql-pods"
}

# The app is to be provisioned
module "so1-java-pod" {
  source = "./modules/so1-java-pod"
}
