variable "namespace" {
  description = "The namespace where service is created"
  type        = string
  default     = "dev"
}

variable "mysql_master_service_name" {
  description = "The name for the mysql master db service"
  type        = string
  default     = "mysql-master"
}

variable "mysql_slave_service_name" {
  description = "The name for the mysql slave db service"
  type        = string
  default     = "mysql-slave"
}

variable "mysql_port" {
  description = "The port api-server service exposes"
  type        = number
  default     = 3306
}

variable "st_master_name" {
  description = "The steteful set name"
  type        = string
  default     = "mysql-master-stateful-set"
}

variable "st_slave_name" {
  description = "The steteful set name"
  type        = string
  default     = "mysql-slave-stateful-set"
}

variable "service_account_master" {
  description = "The service account to use for steteful set name"
  type        = string
  default     = "mysql-master"
}

variable "service_account_slave" {
  description = "The service account to use for steteful set name"
  type        = string
  default     = "mysql-slave"
}

variable "volume_name_master" {
  description = "The namespace where storage provisioned is created"
  type        = string
  default     = "mysql-master-pv"
}

variable "volume_name_slave" {
  description = "The namespace where storage provisioned is created"
  type        = string
  default     = "mysql-slave-pv"
}

variable "username" {
  description = "The name used to access postgres"
  type        = string
  default     = "sa"
}

variable "replication_username" {
  description = "The name used to access postgres"
  type        = string
  default     = "demo"
}

variable "db_name" {
  description = "The database for the user"
  type        = string
  default     = "test"
}

variable "config_name" {
  description = "The name for the config map for postgres"
  type        = string
  default     = "mysql-configmap"
}

variable "container_name_master" {
  description = "The name for the pod"
  type        = string
  default     = "mysql-master"
}

variable "container_name_slave" {
  description = "The name for the pod"
  type        = string
  default     = "mysql-slave"
}

variable "image_reference_master" {
  description = "The name for the docker image to pull"
  type        = string
  default     = "rezesius/mysql-master:v1"
}

variable "image_reference_slave" {
  description = "The name for the docker image to pull"
  type        = string
  default     = "rezesius/mysql-slave:v1"
}
